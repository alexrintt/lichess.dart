import 'dart:convert';

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

  /// Custom implementation of [getTeamMembers] because lichess API
  /// is returning multiple JSON objects in a single line, so retrofit
  /// generator can't generate the object.
  ///
  /// E.g.:
  /// ```
  /// {"id":"user1","username":"user1","title":null,"patron":false,"online":false,"playing":false,"language":"en","url":"/@/user1"}
  /// {"id":"user2","username":"user2","title":null,"patron":false,"online":false,"playing":false,"language":"en","url":"/@/user2"}
  /// ```
  ///
  /// In order to fix this issue, we need to replace the `}\n{` with `},{` and
  /// wrap the whole string with `[]` to make it a valid JSON array.
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamSearch
  @override
  Future<List<User>> getMembers({required String teamId}) async {
    final Response<dynamic> response =
        await dio.get<dynamic>('/api/team/$teamId/users');

    // Api returns data as null if there are no members
    // in the team instead of an empty list.
    if (response.data == null) {
      return <User>[];
    }

    final String data = response.data as String;
    final String formattedData = data.replaceAll('}\n{', '},{');

    final List<dynamic> dataList =
        jsonDecode('[$formattedData]') as List<dynamic>;

    return dataList
        .map((dynamic e) => User.fromJson(e as Map<String, dynamic>))
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
