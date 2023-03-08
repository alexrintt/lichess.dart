import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:shirou/shirou.dart';

part 'client.g.dart';

abstract class ShirouClient {
  /// Interface for this client, if you are looking for a concrete implementation
  /// use [ShiroClient.create] instead.
  const ShirouClient();

  factory ShirouClient.create(
      {String? accessToken, Dio? dio, String? baseUrl}) = ShirouClientImpl;

  /// Whether or not [this] client can perform authenticated requests.
  bool get isLogged;

  /// Public information about the logged in user.
  ///
  /// https://lichess.org/api#tag/Account/operation/accountMe
  Future<User> getMyProfile();

  /// Read the email address of the logged in user.
  ///
  /// https://lichess.org/api#tag/Account/operation/accountEmail
  Future<String> getMyEmailAddress();

  /// Read the preferences of the logged in user.
  ///
  /// - https://lichess.org/account/preferences/game-display.
  /// - https://github.com/ornicar/lila/blob/master/modules/pref/src/main/Pref.scala.
  ///
  /// https://lichess.org/api#tag/Account/operation/account
  Future<UserPreferences> getMyPreferences();

  /// Read the kid mode status of the logged in user.
  ///
  /// https://lichess.org/api#tag/Account/operation/accountKid.
  Future<bool> getMyKidModeStatus();

  /// Set the kid mode status of the logged in user.
  ///
  /// https://lichess.org/api#tag/Account/operation/accountKidPost
  Future<void> setMyKidModeStatus({required bool enableKidMode});

  /// Read public data of a user.
  ///
  /// If the request is [authenticated with OAuth2](https://lichess.org/api#section/Introduction/Authentication),
  /// then extra fields might be present in the response: `followable`, `following`, `blocking`, `followsYou`.
  ///
  /// https://lichess.org/api#tag/Users/operation/apiUser
  Future<User> getUserPublicData({
    required String username,
    bool trophies = false,
  });

  /// Provides autocompletion options for an incomplete username.
  ///
  /// This method set the endpoint [object] param as [true], so it
  /// returns an array of user objects `{id,name,title,patron,online}`.
  ///
  /// https://lichess.org/api#tag/Users/operation/apiPlayerAutocomplete
  Future<List<User>> autocompleteUsers({
    required String term,
    bool friend = false,
  });

  /// Provides autocompletion options for an incomplete username.
  ///
  /// This method set the endpoint [object] param as [false], so it only
  /// returns an array of user usernames `String`.
  ///
  /// https://lichess.org/api#tag/Users/operation/apiPlayerAutocomplete
  Future<List<String>> autocompleteUsernames({
    required String term,
    bool friend = false,
  });

  /// Read rating history of a user, for all perf types.
  ///
  /// There is at most one entry per day. Format of an entry is `[year, month, day, rating]`.
  /// `month` starts at zero (January).
  ///
  /// https://lichess.org/api#tag/Users/operation/apiUserRatingHistory
  Future<List<RatingHistory>> getUserRatingHistory({required String username});

  /// Read the `online`, `playing` and `streaming` flags of several users.
  ///
  /// This API is very fast and cheap on lichess side. So you can call it quite often (like once every 5 seconds).
  ///
  /// Use it to track players and know when they're connected on lichess and playing games.
  ///
  /// https://lichess.org/api#tag/Users/operation/apiUsersStatus
  Future<List<RealTimeUserStatus>> getRealTimeStatusOfSeveralUsers({
    required List<String> ids,
    bool withGameIds = false,
  });

  /// Get up to 300 users by their IDs. Users are returned in the same order as the IDs.
  ///
  /// The method is `POST` to allow a longer list of IDs to be sent in the request body.
  ///
  /// Please do not try to download all the Lichess users with this endpoint, or any other endpoint.
  /// An API is not a way to fully export a website. We do not provide a full download of the Lichess users.
  ///
  /// This endpoint is limited to 8,000 users every 10 minutes, and 120,000 every day.
  ///
  /// https://lichess.org/api#tag/Users/operation/apiUsers
  Future<List<User>> getSeveralUsersById({required List<String> ids});

  /// Get basic info about currently streaming users.
  ///
  /// This API is very fast and cheap on lichess side. So you can call it quite often (like once every 5 seconds).
  ///
  /// https://lichess.org/api#tag/Users/operation/streamerLive
  Future<List<User>> getLiveStreamers();

  /// Get the team based on the given [teamId].
  ///
  /// This API gives you infos about the team, such as the description, leader, etc.
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamShow
  Future<Team> getTeam({required String teamId});

  /// Paginator of the most popular teams.
  ///
  /// This API gives you a page with the given [page] index of the most popular teams.
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamAll
  Future<TeamsPager> getTeamsOnPage({required int page});

  /// Get all teams of a user based on the given [username].
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamOfUsername
  Future<List<Team>> getUserTeams({required String username});

  /// Search for teams based on the given [name].
  /// an optional [page] index can be provided to get a specific page.
  /// The default page is 1.
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamSearch
  Future<TeamsPager> searchTeam({required String name, int page = 1});

  /// Get all members of a team based on the given [teamId].
  ///
  /// Members are sorted by reverse chronological order of joining
  /// the team (most recent first). OAuth only required if the list
  /// of members is private.
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamSearch
  Future<List<TeamMember>> getTeamMembers({required String teamId});

  /// Join a team based on the given [teamId].
  /// An optional [message] can be provided to send a message if the team requires one
  /// Another optional [password] can be provided if the team requires one.
  ///
  /// If the team requires a password but the password field is incorrect,
  /// then the call fails. Similarly,
  /// if the team join policy requires a confirmation
  /// but the message parameter is not given,
  /// then the call fails
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamIdJoin
  Future<void> joinTeam({
    required String teamId,
    String? message,
    String? password,
  });

  /// Release and clear any HTTP resources associated with [this] client.
  Future<void> close({bool force = false});
}

@RestApi(baseUrl: 'https://lichess.org/api')
abstract class ShirouClientImpl implements ShirouClient {
  factory ShirouClientImpl({String? accessToken, Dio? dio, String? baseUrl}) {
    final Dio dioClient = dio ?? Dio();

    if (accessToken != null) {
      dioClient.options.headers['Authorization'] = 'Bearer $accessToken';
    }

    final _ShirouClientImpl shirou = _ShirouClientImpl._(
      // For some reason the [retrofit] package hide their [dio] instance,
      // so we need to define one by ourselves, see the [ShiroClientImpl._] constructor.
      // And by doing that, the [retrofit] generator creates 2 dio args, one for them and one for us.
      dioClient,
      dioClient,
      accessToken != null,
      baseUrl: baseUrl,
    );

    return shirou
      ..dio.options = dioClient.options.copyWith(
        baseUrl: baseUrl ?? shirou.baseUrl!,
      );
  }

  ShirouClientImpl._({required this.dio, required this.hasAccessToken});

  final Dio dio;
  final bool hasAccessToken;

  @override
  bool get isLogged => hasAccessToken;

  @override
  @GET('/account')
  Future<User> getMyProfile();

  @override
  Future<String> getMyEmailAddress() async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>('/account/email');

    return response.data!['email'] as String;
  }

  @override
  Future<UserPreferences> getMyPreferences() async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>('/account/preferences');

    return UserPreferences.fromJson(
      <String, dynamic>{
        'language': response.data!['language'] as String,
        ...response.data!['prefs'] as Map<String, dynamic>,
      },
    );
  }

  @override
  Future<bool> getMyKidModeStatus() async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>('/account/kid');

    return response.data!['kid'] as bool;
  }

  @override
  @POST('/account/kid')
  Future<void> setMyKidModeStatus({@Query('v') required bool enableKidMode});

  @override
  @GET('/user/{username}')
  Future<User> getUserPublicData({
    @Path() required String username,
    @Query('trophies') bool trophies = false,
  });

  /// Workaround to fix the [autocompleteUsers] method because the lichess API
  /// wrong. Read [_customAutocompleteUsers] for more info.
  @override
  Future<List<User>> autocompleteUsers({
    @Query('term') required String term,
    @Query('friend') bool friend = false,
    @Query('object') bool object = true,
  }) async {
    final rawData = await _customAutocompleteUsers(
      term: term,
      friend: friend,
      object: object,
    );
    final results = rawData['result'] as List;
    return results
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Custom implementation of [autocompleteUsers] because lichess API
  /// is returning a `Map<String, dynamic>` instead of a `List<User>` so
  /// retrofit generator can't generate the object.
  ///
  /// This is a workaround to fix this issue by using the [Dio] instance
  /// directly, see https://github.com/lichess-org/api/issues/231.
  Future<Map<String, dynamic>> _customAutocompleteUsers({
    required String term,
    bool friend = false,
    bool object = true,
  }) async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>(
      '/player/autocomplete',
      queryParameters: <String, dynamic>{
        'term': term,
        'friend': friend,
        'object': object,
      },
    );

    return response.data!;
  }

  @override
  @GET('/player/autocomplete')
  Future<List<String>> autocompleteUsernames({
    @Query('term') required String term,
    @Query('friend') bool friend = false,
  });

  @override
  @GET('/user/{username}/rating-history')
  Future<List<RatingHistory>> getUserRatingHistory({
    @Path('username') required String username,
  });

  @override
  @GET('/users/status')
  Future<List<RealTimeUserStatus>> getRealTimeStatusOfSeveralUsers({
    @Query('ids') required List<String> ids,
    @Query('withGameIds') bool withGameIds = false,
  });

  @override
  Future<List<User>> getSeveralUsersById({
    required List<String> ids,
  }) async {
    final formattedIds = ids.join(',');
    final Response<List<dynamic>> response =
        await dio.post<List<dynamic>>('/users', data: formattedIds);

    return response.data!
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  @GET('/streamer/live')
  Future<List<User>> getLiveStreamers();

  @override
  @GET('/team/{teamId}')
  Future<Team> getTeam({@Path('teamId') required String teamId});

  @override
  @GET('/team/all')
  Future<TeamsPager> getTeamsOnPage({@Query('page') required int page});

  @override
  @GET('/team/of/{username}')
  Future<List<Team>> getUserTeams({
    @Path('username') required String username,
  });

  @override
  @GET('/team/search')
  Future<TeamsPager> searchTeam({
    @Query('text') required String name,
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
  Future<List<TeamMember>> getTeamMembers({
    required String teamId,
  }) async {
    final Response<dynamic> response =
        await dio.get<dynamic>('/team/$teamId/users');

    final data = response.data as String;
    final formattedData = data.replaceAll('}\n{', '},{');

    final dataList = jsonDecode('[$formattedData]') as List<dynamic>;

    return dataList
        .map((e) => TeamMember.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  @FormUrlEncoded()
  @POST('/team/{teamId}/join')
  Future<void> joinTeam({
    @Path('teamId') required String teamId,
    @Field('message') String? message,
    @Field('password') String? password,
  });

  @override
  Future<void> close({bool force = false}) async => dio.close(force: force);
}

class LichessException implements Exception {
  const LichessException(this.message, [this.code]);

  final String message;
  final String? code;
}

class LichessUnauthenticatedException extends LichessException {
  const LichessUnauthenticatedException()
      : super(
          'You are trying to access an authenticated resource without an access token.',
          'LichessUnauthenticatedException',
        );
}

class NotImplementedError extends Error {}
