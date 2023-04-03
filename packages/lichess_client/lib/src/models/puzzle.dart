import 'package:freezed_annotation/freezed_annotation.dart';

import '../../lichess_client.dart';

part 'puzzle.freezed.dart';
part 'puzzle.g.dart';

@freezed
class LichessPuzzlePlayer with _$LichessPuzzlePlayer {
  const factory LichessPuzzlePlayer({
    String? color,
    String? name,
    String? userId,
  }) = _LichessPuzzlePlayer;

  factory LichessPuzzlePlayer.fromJson(Map<String, dynamic> json) =>
      _$LichessPuzzlePlayerFromJson(json);
}

@freezed
class PuzzleGame with _$PuzzleGame {
  const factory PuzzleGame({
    String? id,
    String? clock,
    Perf? perf,
    String? pgn,
    @JsonKey(name: 'players') List<LichessPuzzlePlayer>? playersAsList,
    bool? rated,
  }) = _PuzzleGame;
  factory PuzzleGame.fromJson(Map<String, dynamic> json) =>
      _$PuzzleGameFromJson(json);

  const PuzzleGame._();

  LichessPuzzlePlayer? get white => playersAsList?.any(
              (LichessPuzzlePlayer element) => element.color == 'white') ??
          false
      ? playersAsList?.firstWhere(
          (LichessPuzzlePlayer element) => element.color == 'white')
      : null;

  LichessPuzzlePlayer? get black => playersAsList?.any(
              (LichessPuzzlePlayer element) => element.color == 'black') ??
          false
      ? playersAsList?.firstWhere(
          (LichessPuzzlePlayer element) => element.color == 'black')
      : null;
}

@freezed
class PuzzleInfo with _$PuzzleInfo {
  const factory PuzzleInfo({
    String? id,
    int? initialPly,
    int? plays,
    int? rating,
    List<String>? solution,
    List<String>? themes,
  }) = _PuzzleInfo;

  factory PuzzleInfo.fromJson(Map<String, dynamic> json) =>
      _$PuzzleInfoFromJson(json);
}

@freezed
class Puzzle with _$Puzzle {
  const factory Puzzle({
    PuzzleGame? game,
    PuzzleInfo? info,
  }) = _Puzzle;

  factory Puzzle.fromJson(Map<String, dynamic> json) => _$PuzzleFromJson(json);
}

@freezed
class PuzzleActivity with _$PuzzleActivity {
  const factory PuzzleActivity({
    String? id,
    int? date,
    bool? win,
    int? puzzleRating,
  }) = _PuzzleActivity;

  factory PuzzleActivity.fromJson(Map<String, dynamic> json) =>
      _$PuzzleActivityFromJson(json);
}

@freezed
class PuzzleResult with _$PuzzleResult {
  const factory PuzzleResult({
    int? firstWins,
    int? nb,
    int? perfomance,
    int? puzzleRatingAvg,
    int? replayWins,
  }) = _PuzzleResult;

  factory PuzzleResult.fromJson(Map<String, dynamic> json) =>
      _$PuzzleResultFromJson(json);
}

@freezed
class PuzzleTheme with _$PuzzleTheme {
  const factory PuzzleTheme({
    PuzzleResult? results,
    String? theme,
  }) = _PuzzleTheme;

  factory PuzzleTheme.fromJson(Map<String, dynamic> json) =>
      _$PuzzleThemeFromJson(json);
}

@freezed
class PuzzleDashboard with _$PuzzleDashboard {
  const factory PuzzleDashboard({
    List<Map<String, PuzzleTheme>>? themes,
  }) = _PuzzleDashboard;

  factory PuzzleDashboard.fromJson(Map<String, dynamic> json) =>
      _$PuzzleDashboardFromJson(json);
}
