import '../../lichess_client.dart';

/// {@template relations}
/// Access relations between users.
///
/// https://lichess.org/api#tag/Relations
/// {@endtemplate}
abstract class RelationsService with CloseableMixin {
  /// Interface for this client.
  const RelationsService();

  /// Get users followed by the logged in user.
  ///
  /// https://lichess.org/api#tag/Relations/operation/apiUserFollowing
  Future<List<User>> getFollowing();

  /// Follow a player, adding them to your list of Lichess friends.
  ///
  /// https://lichess.org/api#tag/Relations/operation/followUser
  Future<void> followUser({required String username});

  /// Unfollow a player, removing them from your list of Lichess friends.
  ///
  /// https://lichess.org/api#tag/Relations/operation/unfollowUser
  Future<void> unfollowUser({required String username});
}
