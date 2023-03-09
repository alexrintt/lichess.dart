import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lichess_client/lichess_client.dart';
import 'package:retrofit/http.dart';

part 'client.g.dart';

abstract class LichessClient {
  /// Interface for this client, if you are looking for a concrete implementation
  /// use [LichessClient.create] instead.
  const LichessClient();

  factory LichessClient.create({
    String? accessToken,
    Dio? dio,
    String? baseUrl,
  }) = LichessClientImpl;

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

  /// Follow a player, adding them to your list of Lichess friends.
  ///
  /// https://lichess.org/api#tag/Relations/operation/followUser
  Future<void> followUser({required String username});

  /// Unfollow a player, removing them from your list of Lichess friends.
  ///
  /// https://lichess.org/api#tag/Relations/operation/unfollowUser
  Future<void> unfollowUser({required String username});

  /// Get users followed by the logged in user.
  ///
  /// https://lichess.org/api#tag/Relations/operation/apiUserFollowing
  Future<List<User>> getMyFollows();

  /// Release and clear any HTTP resources associated with [this] client.
  Future<void> close({bool force = false});
}

@RestApi(baseUrl: 'https://lichess.org')
abstract class LichessClientImpl implements LichessClient {
  factory LichessClientImpl({String? accessToken, Dio? dio, String? baseUrl}) {
    final Dio dioClient = dio ?? Dio();

    if (accessToken != null) {
      dioClient.options.headers['Authorization'] = 'Bearer $accessToken';
    }

    final _LichessClientImpl lichess = _LichessClientImpl._(
      // For some reason the [retrofit] package hide their [dio] instance,
      // so we need to define one by ourselves, see the [LichessClientImpl._] constructor.
      // And by doing that, the [retrofit] generator creates 2 dio args, one for them and one for us.
      dioClient,
      dioClient,
      accessToken != null,
      baseUrl: baseUrl,
    );

    return lichess
      ..dio.options = dioClient.options.copyWith(
        baseUrl: baseUrl ?? lichess.baseUrl!,
      );
  }

  LichessClientImpl._({required this.dio, required this.hasAccessToken});

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
        await dio.get<Map<String, dynamic>>('/api/account/email');

    return response.data!['email'] as String;
  }

  @override
  Future<UserPreferences> getMyPreferences() async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>('/api/account/preferences');

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
        await dio.get<Map<String, dynamic>>('api/account/kid');

    return response.data!['kid'] as bool;
  }

  @override
  @POST('/api/account/kid')
  Future<void> setMyKidModeStatus({@Query('v') required bool enableKidMode});

  @override
  @GET('/api/user/{username}')
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
    final Map<String, dynamic> rawData = await _customAutocompleteUsers(
      term: term,
      friend: friend,
      object: object,
    );
    final List<dynamic> results = rawData['result'] as List<dynamic>;
    return results
        .map((dynamic e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Custom implementation of [autocompleteUsers] because Lichess API
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
      '/api/player/autocomplete',
      queryParameters: <String, dynamic>{
        'term': term,
        'friend': friend,
        'object': object,
      },
    );

    return response.data!;
  }

  @override
  @GET('/api/player/autocomplete')
  Future<List<String>> autocompleteUsernames({
    @Query('term') required String term,
    @Query('friend') bool friend = false,
  });

  @override
  @GET('/api/user/{username}/rating-history')
  Future<List<RatingHistory>> getUserRatingHistory({
    @Path('username') required String username,
  });

  @override
  @GET('/api/users/status')
  Future<List<RealTimeUserStatus>> getRealTimeStatusOfSeveralUsers({
    @Query('ids') required List<String> ids,
    @Query('withGameIds') bool withGameIds = false,
  });

  @override
  Future<List<User>> getSeveralUsersById({
    required List<String> ids,
  }) async {
    final String formattedIds = ids.join(',');
    final Response<List<dynamic>> response =
        await dio.post<List<dynamic>>('/api/users', data: formattedIds);

    return response.data!
        .map((dynamic e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  @GET('/api/streamer/live')
  Future<List<User>> getLiveStreamers();

  @override
  @POST('/api/rel/follow/{username}')
  Future<void> followUser({@Path() required String username});

  @override
  @POST('/api/rel/unfollow/{username}')
  Future<void> unfollowUser({required String username});

  @override
  Future<List<User>> getMyFollows() async {
    final Response<String> ndjson = await dio.get<String>('/rel/following');

    final List<String> rawFollows = ndjson.data != null
        ? const LineSplitter().convert(ndjson.data!)
        : <String>[];

    bool allKeysAreStrings(dynamic e) =>
        e is Map && e.keys.every((dynamic key) => key is String);

    final List<User> follows = rawFollows
        .map(jsonDecode)
        .where(allKeysAreStrings)
        .cast<Map<String, dynamic>>()
        .map(User.fromJson)
        .toList();

    return follows;
  }

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
