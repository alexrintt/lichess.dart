import '../models/puzzle.dart';

abstract class PuzzleService {
  /// Get the Daily puzzle.
  Future<Puzzle> getDailyPuzzle();

  /// Get a puzzle by its ID.
  Future<Puzzle> getPuzzleById({required String id});

  /// Download you puzzle activity
  /// Puzzle activity is sorted by reverse chronological order (most recent first)
  ///
  /// [max] is the maximum number of puzzle activities to return.
  /// If not specified, all puzzle activities will be returned.
  Stream<PuzzleActivity> getPuzzleActivity({int? max});

  /// Get your puzzle dashboard
  ///
  /// [days] is the number of days to look back for the puzzle dashboard.
  /// If not specified, the puzzle dashboard will be returned for the last 30 days.
  Future<PuzzleDashboard> getPuzzleDashboard({int days = 30});
}
