import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../lichess_client_dio.dart';

part 'teams_service.g.dart';

@RestApi()
abstract class TeamsServiceDio implements TeamsService {
  factory TeamsServiceDio(Dio dio) => _TeamsServiceDio._(dio, dio);

  factory TeamsServiceDio.create({
    String? accessToken,
    String baseUrl = 'https://lichess.org',
  }) =>
      TeamsServiceDio(
        createLichessDioClientWith(accessToken: accessToken, baseUrl: baseUrl),
      );

  const TeamsServiceDio._(this.dio);

  final Dio dio;

  @override
  @GET('/api/team/{teamId}')
  Future<Team> getById(@Path('teamId') String teamId);

  @override
  @GET('/api/team/all')
  Future<PageOf<Team>> getPopular({@Query('page') int page = 1});

  @override
  @GET('/api/team/of/{username}')
  Future<List<Team>> getByUser({
    @Path('username') required String username,
  });

  @override
  @GET('/api/team/search')
  Future<PageOf<Team>> search({
    @Query('text') required String text,
    @Query('page') int page = 1,
  });

  /// Members are sorted by reverse chronological order of joining the team (most recent first). OAuth only required if the list of members is private.
  ///
  /// Members are streamed as ndjson.
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamIdUsers
  @override
  Future<List<User>> getMembers({
    required String teamId,
    int limit = 20,
  }) async {
    final Response<ResponseBody> response = await dio.get<ResponseBody>(
      '/api/team/$teamId/users',
      options: Options(responseType: ResponseType.stream),
    );

    final StringBuffer buffer = StringBuffer();
    List<String> objs = <String>[];

    await for (final Uint8List chunk
        in response.data?.stream ?? const Stream<Uint8List>.empty()) {
      buffer.write(utf8.decode(chunk));

      objs = const LineSplitter().convert(buffer.toString());

      if (objs.length >= limit) {
        break;
      }
    }

    return objs
        .take(limit)
        .map(jsonDecode)
        .cast<Map<dynamic, dynamic>>()
        .map(Map<String, dynamic>.from)
        .map(User.fromJson)
        .cast<User>()
        .toList();
  }

  @override
  @FormUrlEncoded()
  @POST('/team/{teamId}/join')
  Future<void> join({
    @Path('teamId') required String teamId,
    @Field('message') String? message,
    @Field('password') String? password,
  });

  @override
  @POST('/team/{teamId}/quit')
  Future<void> leave({@Path('teamId') required String teamId});

  @override
  Future<List<JoinRequest>> getJoinRequests({required String teamId}) async {
    final Response<List<dynamic>> response =
        await dio.get<List<dynamic>>('/api/team/$teamId/requests');

    if (response.data == null) {
      return <JoinRequest>[];
    }

    final List<Map<String, dynamic>> requests =
        response.data!.map((dynamic e) => e as Map<String, dynamic>).toList();
    return requests
        .map(
          (Map<String, dynamic> e) => JoinRequest(
            userId: (e['request'] as Map<String, dynamic>)['userId'] as String,
            date: (e['request'] as Map<String, dynamic>)['date'] as int,
            message:
                (e['request'] as Map<String, dynamic>)['message'] as String?,
            teamId: (e['request'] as Map<String, dynamic>)['teamId'] as String,
            user: User.fromJson(e['user'] as Map<String, dynamic>),
          ),
        )
        .toList();
  }

  @override
  @POST('/api/team/{teamId}/request/{userId}/accept')
  Future<void> acceptJoinRequest({
    @Path('teamId') required String teamId,
    @Path('userId') required String userId,
  });

  @override
  @POST('/api/team/{teamId}/request/{userId}/decline')
  Future<void> declineJoinRequest({
    @Path('teamId') required String teamId,
    @Path('userId') required String userId,
  });

  @override
  @POST('/team/{teamId}/kick/{userId}')
  Future<void> kickMember({
    @Path('teamId') required String teamId,
    @Path('userId') required String userId,
  });

  @override
  @FormUrlEncoded()
  @POST('/team/{teamId}/pm-all')
  Future<void> messageAllMembers({
    @Path('teamId') required String teamId,
    @Field('message') required String message,
  });

  @override
  Future<void> close({bool force = false}) async => dio.close(force: force);
}
