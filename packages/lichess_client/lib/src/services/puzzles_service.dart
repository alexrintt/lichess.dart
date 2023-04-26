import '../models/puzzle.dart';

/// {@template puzzles}
/// Read information about puzzles.
///
/// https://lichess.org/api#tag/Puzzles
/// {@endtemplate}
abstract class PuzzlesService {
  /// Interface for this client.
  const PuzzlesService();

  /// Get the Daily puzzle.
  ///
  /// https://lichess.org/api#tag/Puzzles/operation/apiPuzzleDaily
  Future<LichessPuzzle> getDailyPuzzle();

  /// Get a puzzle by its ID.
  ///
  /// https://lichess.org/api#tag/Puzzles/operation/apiPuzzleId
  Future<LichessPuzzle> getPuzzleById({required String id});

  /// Download you puzzle activity
  /// Puzzle activity is sorted by reverse chronological order (most recent first)
  ///
  /// [max] is the maximum number of puzzle activities to return.
  /// If not specified, all puzzle activities will be returned.
  ///
  /// https://lichess.org/api#tag/Puzzles/operation/apiPuzzleActivity
  Stream<LichessPuzzleActivity> getPuzzleActivity({int? max});

  /// Get your puzzle dashboard
  ///
  /// [days] is the number of days to look back for the puzzle dashboard.
  /// If not specified, the puzzle dashboard will be returned for the last 30 days.
  ///
  /// https://lichess.org/api#tag/Puzzles/operation/apiPuzzleDashboard
  Future<LichessPuzzleDashboard> getPuzzleDashboard({int days = 30});
}
