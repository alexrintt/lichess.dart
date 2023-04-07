import '../lichess_client.dart';

/// Interface for this client, if you are looking for a concrete implementation
/// use [LichessClientDio.create] from [lichess_client_dio] package instead.
abstract class LichessClient with CloseableMixin {
  const LichessClient();

  /// {@macro account}
  AccountService get account;

  /// {@macro users}
  UsersService get users;

  /// {@macro relations}
  RelationsService get relations;

  /// {@macro teams}
  TeamsService get teams;

  /// {@macro tv}
  TvService get tv;

  /// {@macro tv}
  GamesService get games;

  /// {@macro puzzles}
  PuzzlesService get puzzles;

  /// Alternative name to [relations].
  RelationsService get social => relations;
}
