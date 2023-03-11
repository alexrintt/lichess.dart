import '../../lichess_client.dart';

/// {@template users}
/// Access registered users on Lichess. https://lichess.org/player
///
/// - Each user blog exposes an atom (RSS) feed, like https://lichess.org/@/thibault/blog.atom.
/// - User blogs mashup feed: https://lichess.org/blog/community.atom.
/// - User blogs mashup feed for a language: https://lichess.org/blog/community/fr.atom.
///
/// https://lichess.org/api#tag/Users
/// {@endtemplate}
abstract class UsersService with CloseableMixin {
  const UsersService();

  /// Read the `online`, `playing` and `streaming` flags of several users.
  ///
  /// This API is very fast and cheap on lichess side. So you can call it quite often (like once every 5 seconds).
  ///
  /// Use it to track players and know when they're connected on lichess and playing games.
  ///
  /// https://lichess.org/api#tag/Users/operation/apiUsersStatus
  Future<List<RealTimeUserStatus>> getRealTimeStatus({
    required List<String> ids,
    bool withGameIds = false,
  });

  /// Get the top 10 players for each speed and variant.
  ///
  /// https://lichess.org/api#tag/Users/operation/player
  Future<Map<String, List<User>>> getTop10();

  /// {@template users.getoneleaderboard}
  /// Get the leaderboard for a single speed or variant (a.k.a. `perfType`).
  /// There is no leaderboard for correspondence or puzzles.
  ///
  /// https://lichess.org/api#tag/Users/operation/playerTopNbPerfType
  /// {@endtemplate}
  Future<List<User>> getPerfTypeLeaderboard({
    required PerfType perfType,
    int nb = 100,
  });

  /// Method with semantic names for [getPerfTypeLeaderboard].
  ///
  /// {@macro users.getoneleaderboard}
  Future<List<User>> getChessVariantLeaderboard({
    required PerfType variant,
    int limit = 100,
  }) =>
      getPerfTypeLeaderboard(
        nb: limit,
        perfType: variant,
      );

  /// Read public data of a user.
  ///
  /// If the request is [authenticated with OAuth2](https://lichess.org/api#section/Introduction/Authentication),
  /// then extra fields might be present in the response: `followable`, `following`, `blocking`, `followsYou`.
  ///
  /// https://lichess.org/api#tag/Users/operation/apiUser
  Future<User> getPublicData({
    required String username,
    bool trophies = false,
  });

  /// Read rating history of a user, for all perf types.
  ///
  /// There is at most one entry per day. Format of an entry is `[year, month, day, rating]`.
  /// `month` starts at zero (January).
  ///
  /// https://lichess.org/api#tag/Users/operation/apiUserRatingHistory
  Future<List<RatingHistory>> getRatingHistory({required String username});

  // TODO: getPerformanceStatistics()
  // TODO: getActivity()

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
  Future<List<User>> getManyById({required List<String> ids});

  // TODO: getTeamMembers()

  /// Get basic info about currently streaming users.
  ///
  /// This API is very fast and cheap on lichess side. So you can call it quite often (like once every 5 seconds).
  ///
  /// https://lichess.org/api#tag/Users/operation/streamerLive
  Future<List<User>> getLiveStreamers();

  // TODO: getCrosstable()

  /// Provides autocompletion options for an incomplete username.
  ///
  /// This method set the endpoint [object] param as [true], so it
  /// returns an array of user objects `{id,name,title,patron,online}`.
  ///
  /// https://lichess.org/api#tag/Users/operation/apiPlayerAutocomplete
  Future<List<User>> autocomplete({
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

  @override
  Future<void> close({bool force = false});
}
