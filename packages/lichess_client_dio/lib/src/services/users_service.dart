import 'package:dio/dio.dart';
import 'package:lichess_client/lichess_client.dart';
import 'package:retrofit/http.dart';

import '../utils/create_dio_client_with.dart';

part 'users_service.g.dart';

/// {@template users}
/// Access registered users on Lichess. https://lichess.org/player
///
/// - Each user blog exposes an atom (RSS) feed, like https://lichess.org/@/thibault/blog.atom.
/// - User blogs mashup feed: https://lichess.org/blog/community.atom.
/// - User blogs mashup feed for a language: https://lichess.org/blog/community/fr.atom.
///
/// https://lichess.org/api#tag/Users
/// {@endtemplate}
@RestApi()
abstract class UsersServiceDio extends UsersService {
  factory UsersServiceDio(Dio dio) => _UsersServiceDio._(dio, dio);

  factory UsersServiceDio.create({
    String? accessToken,
    String baseUrl = 'https://lichess.org',
  }) =>
      UsersServiceDio(
        createLichessDioClientWith(accessToken: accessToken, baseUrl: baseUrl),
      );

  const UsersServiceDio._(this.dio);

  /// Dio client linked with this service instance.
  final Dio dio;

  /// Read the `online`, `playing` and `streaming` flags of several users.
  ///
  /// This API is very fast and cheap on lichess side. So you can call it quite often (like once every 5 seconds).
  ///
  /// Use it to track players and know when they're connected on lichess and playing games.
  ///
  /// https://lichess.org/api#tag/Users/operation/apiUsersStatus
  @override
  @GET('/api/users/status')
  Future<List<RealTimeUserStatus>> getRealTimeStatus({
    @Query('ids') required List<String> ids,
    @Query('withGameIds') bool withGameIds = false,
  });

  /// Get the top 10 players for each speed and variant.
  ///
  /// https://lichess.org/api#tag/Users/operation/player
  @override
  Future<Map<String, List<User>>> getTop10() {
    // TODO: implement getTop10
    throw UnimplementedError();
  }

  /// {@template users.getoneleaderboard}
  /// Get the leaderboard for a single speed or variant (a.k.a. `perfType`).
  /// There is no leaderboard for correspondence or puzzles.
  ///
  /// https://lichess.org/api#tag/Users/operation/playerTopNbPerfType
  /// {@endtemplate}
  @override
  Future<List<User>> getPerfTypeLeaderboard({
    required PerfType perfType,
    int nb = 100,
  }) {
    // TODO: implement getPerfTypeLeaderboard
    throw UnimplementedError();
  }

  /// Method with semantic names for [getPerfTypeLeaderboard].
  ///
  /// {@macro users.getoneleaderboard}
  @override
  Future<List<User>> getChessVariantLeaderboard({
    required PerfType variant,
    int limit = 100,
  }) {
    // TODO: implement getChessVariantLeaderboard
    throw UnimplementedError();
  }

  /// Read public data of a user.
  ///
  /// If the request is [authenticated with OAuth2](https://lichess.org/api#section/Introduction/Authentication),
  /// then extra fields might be present in the response: `followable`, `following`, `blocking`, `followsYou`.
  ///
  /// https://lichess.org/api#tag/Users/operation/apiUser
  @override
  @GET('/api/user/{username}')
  Future<User> getPublicData({
    @Path() required String username,
    @Query('trophies') bool trophies = false,
  });

  /// Read rating history of a user, for all perf types.
  ///
  /// There is at most one entry per day. Format of an entry is `[year, month, day, rating]`.
  /// `month` starts at zero (January).
  ///
  /// https://lichess.org/api#tag/Users/operation/apiUserRatingHistory
  @override
  @GET('/api/user/{username}/rating-history')
  Future<List<RatingHistory>> getRatingHistory({
    @Path('username') required String username,
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
  @override
  Future<List<User>> getManyById({
    required List<String> ids,
  }) async {
    final String formattedIds = ids.join(',');
    final Response<List<dynamic>> response =
        await dio.post<List<dynamic>>('/api/users', data: formattedIds);

    return response.data!
        .map((dynamic e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get basic info about currently streaming users.
  ///
  /// This API is very fast and cheap on lichess side. So you can call it quite often (like once every 5 seconds).
  ///
  /// https://lichess.org/api#tag/Users/operation/streamerLive
  @override
  @GET('/api/streamer/live')
  Future<List<User>> getLiveStreamers();

  /// Provides autocompletion options for an incomplete username.
  ///
  /// This method set the endpoint [object] param as [true], so it
  /// returns an array of user objects `{id,name,title,patron,online}`.
  ///
  /// https://lichess.org/api#tag/Users/operation/apiPlayerAutocomplete
  @override
  Future<List<User>> searchByTerm({
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

    final Map<String, dynamic> rawData = response.data!;

    final List<dynamic> results = rawData['result'] as List<dynamic>;

    return results
        .map((dynamic e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Provides autocompletion options for an incomplete username.
  ///
  /// This method set the endpoint [object] param as [false], so it only
  /// returns an array of user usernames `String`.
  ///
  /// https://lichess.org/api#tag/Users/operation/apiPlayerAutocomplete
  @override
  @GET('/api/player/autocomplete')
  Future<List<String>> searchNamesByTerm({
    @Query('term') required String term,
    @Query('friend') bool friend = false,
  });

  /// Close the [dio] instance associated with this service instance.
  ///
  /// Note that you will not be able to use other service that uses this same [dio] instance.
  @override
  Future<void> close({bool force = false}) async => dio.close(force: force);
}
