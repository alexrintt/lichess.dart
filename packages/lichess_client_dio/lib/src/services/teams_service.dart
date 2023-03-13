import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../lichess_client_dio.dart';

part 'teams_service.g.dart';

/// {@template teams}
/// Access and manage Lichess teams and their members.
///
/// https://lichess.org/api#tag/Teams
/// {@endtemplate}
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

  /// Dio client linked with this service instance.
  final Dio dio;

  /// Get the team based on the given [teamId].
  ///
  /// This API gives you infos about the team, such as the description, leader, etc.
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamShow
  @override
  @GET('/api/team/{teamId}')
  Future<Team> getById(@Path('teamId') String teamId);

  /// Paginator of the most popular teams.
  ///
  /// This API gives you a page with the given [page] index of the most popular teams.
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamAll
  @override
  @GET('/api/team/all')
  Future<PageOf<Team>> getPopular({@Query('page') int page = 1});

  /// Get all teams of a user based on the given [username].
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamOfUsername
  @override
  @GET('/api/team/of/{username}')
  Future<List<Team>> getByUser({
    @Path('username') required String username,
  });

  /// Search for teams based on the given [name]. An optional [page] index  can be provided to get a specific page.
  ///
  /// The default page is 1.
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamSearch
  @override
  @GET('/api/team/search')
  Future<PageOf<Team>> search({
    @Query('text') required String text,
    @Query('page') int page = 1,
  });

  /// Get all members of a team based on the given [teamId].
  ///
  /// Members are sorted by reverse chronological order of joining
  /// the team (most recent first). OAuth only required if the list
  /// of members is private.
  ///
  /// Since the API returns a stremed ndjson, this method also returns a [Stream].
  ///
  /// Use [stream.listen] to start fetching items.
  ///
  /// Use [listener.pause] and [listener.resume] to implement a backpressure, that is,
  /// call [listener.pause] to pause the members stream (e.g the user stopped scrolling down)
  /// and call [stream.resume] and the user request more items (e.g the user scrolled down and the list needs to show more items).
  ///
  /// Don't forget to call [listener.cancel] to close the HTTP request.
  ///
  /// Remember to implement [listener.onDone] and [listener.onError] when calling [stream.listen]
  /// to handle when there are no more items to be fetched and when a error occurs.
  ///
  /// Ref: https://github.com/lichess-org/lila/issues/12502.
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamSearch
  @override
  Stream<User> getMembers({required String teamId}) async* {
    final Response<ResponseBody> response = await dio.get<ResponseBody>(
      '/api/team/$teamId/users',
      options: Options(responseType: ResponseType.stream),
    );

    final StringBuffer buffered = StringBuffer();

    await for (final Uint8List part
        in response.data?.stream ?? const Stream<Uint8List>.empty()) {
      final String chunk = utf8.decode(part);

      buffered.write(chunk);

      late int i;

      while ((i = buffered.toString().indexOf('\n')) != -1) {
        final String obj = buffered.toString().substring(0, i);
        final String rest = buffered.toString().substring(i + 1);

        buffered.clear();
        buffered.write(rest);

        if (obj.isEmpty) {
          continue;
        }

        final dynamic raw = jsonDecode(obj);

        if (raw is Map<dynamic, dynamic>) {
          yield User.fromJson(Map<String, dynamic>.from(raw));
        }
      }
    }
  }

  /// Join a team based on the given [teamId].
  /// An optional [message] can be provided to send a message if the team requires one.
  ///
  /// Another optional [password] can be provided if the team requires one.
  ///
  /// If the team requires a password but the password field is incorrect,
  /// then the call fails. Similarly, if the team join policy requires a confirmation
  /// but the message parameter is not given, the call fails.
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamIdJoin
  @override
  @FormUrlEncoded()
  @POST('/team/{teamId}/join')
  Future<void> join({
    @Path('teamId') required String teamId,
    @Field('message') String? message,
    @Field('password') String? password,
  });

  /// Leave a team based on the given [teamId].
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamIdQuit
  @override
  @POST('/team/{teamId}/quit')
  Future<void> leave({@Path('teamId') required String teamId});

  /// Get pending join requests for a team based on the given [teamId].
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamRequests
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

  /// Accept a join request for a team based on the given [teamId] and [userId].
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamRequestAccept
  @override
  @POST('/api/team/{teamId}/request/{userId}/accept')
  Future<void> acceptJoinRequest({
    @Path('teamId') required String teamId,
    @Path('userId') required String userId,
  });

  /// Decline a join request for a team based on the given [teamId] and [userId].
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamRequestDecline
  @override
  @POST('/api/team/{teamId}/request/{userId}/decline')
  Future<void> declineJoinRequest({
    @Path('teamId') required String teamId,
    @Path('userId') required String userId,
  });

  /// Kick a user from a team based on the given [teamId] and [userId].
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamIdKickUserId
  @override
  @POST('/team/{teamId}/kick/{userId}')
  Future<void> kickMember({
    @Path('teamId') required String teamId,
    @Path('userId') required String userId,
  });

  /// Send a privatte message to all members of a team.
  ///
  /// NOTICE: You must own the team.
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamIdPmAll
  @override
  @FormUrlEncoded()
  @POST('/team/{teamId}/pm-all')
  Future<void> messageAllMembers({
    @Path('teamId') required String teamId,
    @Field('message') required String message,
  });

  /// Close the [dio] instance associated with this service instance.
  ///
  /// Note that you will not be able to use other service that uses this same [dio] instance.
  @override
  Future<void> close({bool force = false}) async => dio.close(force: force);
}
