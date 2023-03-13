import '../../lichess_client.dart';

/// {@template teams}
/// Access and manage Lichess teams and their members.
///
/// https://lichess.org/api#tag/Teams
/// {@endtemplate}
abstract class TeamsService with CloseableMixin {
  const TeamsService();

  /// Get the team based on the given [teamId].
  ///
  /// This API gives you infos about the team, such as the description, leader, etc.
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamShow
  Future<Team> getById(String teamId);

  /// Paginator of the most popular teams.
  ///
  /// This API gives you a page with the given [page] index of the most popular teams.
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamAll
  Future<PageOf<Team>> getPopular({int page = 1});

  /// Get all teams of a user based on the given [username].
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamOfUsername
  Future<List<Team>> getByUser({required String username});

  /// Search for teams based on the given [name]. An optional [page] index  can be provided to get a specific page.
  ///
  /// The default page is 1.
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamSearch
  Future<PageOf<Team>> search({required String text, int page = 1});

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
  Stream<User> getMembers({required String teamId});

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
  Future<void> join({
    required String teamId,
    String? message,
    String? password,
  });

  /// Leave a team based on the given [teamId].
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamIdQuit
  Future<void> leave({required String teamId});

  /// Get pending join requests for a team based on the given [teamId].
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamRequests
  Future<List<JoinRequest>> getJoinRequests({required String teamId});

  /// Accept a join request for a team based on the given [teamId] and [userId].
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamRequestAccept
  Future<void> acceptJoinRequest({
    required String teamId,
    required String userId,
  });

  /// Decline a join request for a team based on the given [teamId] and [userId].
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamRequestDecline
  Future<void> declineJoinRequest({
    required String teamId,
    required String userId,
  });

  /// Kick a user from a team based on the given [teamId] and [userId].
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamIdKickUserId
  Future<void> kickMember({
    required String teamId,
    required String userId,
  });

  /// Send a privatte message to all members of a team.
  ///
  /// NOTICE: You must own the team.
  ///
  /// https://lichess.org/api#tag/Teams/operation/teamIdPmAll
  Future<void> messageAllMembers({
    required String teamId,
    required String message,
  });
}
