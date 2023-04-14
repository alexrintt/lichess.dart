import 'package:freezed_annotation/freezed_annotation.dart';

import '../../lichess_client.dart';

part 'puzzle.freezed.dart';
part 'puzzle.g.dart';

@freezed
class LichessPuzzlePlayer with _$LichessPuzzlePlayer {
  const factory LichessPuzzlePlayer({
    LichessColor? color,
    String? name,
    String? userId,
  }) = _LichessPuzzlePlayer;

  factory LichessPuzzlePlayer.fromJson(Map<String, dynamic> json) =>
      _$LichessPuzzlePlayerFromJson(json);
}

@freezed
class LichessPuzzleGame with _$LichessPuzzleGame {
  const factory LichessPuzzleGame({
    String? id,
    String? clock,
    Perf? perf,
    String? pgn,
    @JsonKey(name: 'players') List<LichessPuzzlePlayer>? playersAsList,
    bool? rated,
  }) = _LichessPuzzleGame;
  factory LichessPuzzleGame.fromJson(Map<String, dynamic> json) =>
      _$LichessPuzzleGameFromJson(json);

  const LichessPuzzleGame._();

  LichessPuzzlePlayer? get white =>
      playersAsList?.cast<LichessPuzzlePlayer?>().firstWhere(
            (LichessPuzzlePlayer? element) => element?.color?.isWhite ?? false,
            orElse: () => null,
          );

  LichessPuzzlePlayer? get black =>
      playersAsList?.cast<LichessPuzzlePlayer?>().firstWhere(
            (LichessPuzzlePlayer? element) => element?.color?.isBlack ?? false,
            orElse: () => null,
          );
}

@freezed
class LichessPuzzleInfo with _$LichessPuzzleInfo {
  const factory LichessPuzzleInfo({
    String? id,
    int? initialPly,
    int? plays,
    int? rating,
    List<String>? solution,
    List<String>? themes,
  }) = _LichessPuzzleInfo;

  factory LichessPuzzleInfo.fromJson(Map<String, dynamic> json) =>
      _$LichessPuzzleInfoFromJson(json);
}

@freezed
class LichessPuzzle with _$LichessPuzzle {
  const factory LichessPuzzle({
    LichessPuzzleGame? game,
    LichessPuzzleInfo? info,
  }) = _LichessPuzzle;

  factory LichessPuzzle.fromJson(Map<String, dynamic> json) =>
      _$LichessPuzzleFromJson(json);
}

@freezed
class LichessPuzzleActivity with _$LichessPuzzleActivity {
  const factory LichessPuzzleActivity({
    String? id,
    int? date,
    bool? win,
    int? puzzleRating,
  }) = _LichessPuzzleActivity;

  factory LichessPuzzleActivity.fromJson(Map<String, dynamic> json) =>
      _$LichessPuzzleActivityFromJson(json);
}

@freezed
class LichessPuzzleResult with _$LichessPuzzleResult {
  const factory LichessPuzzleResult({
    int? firstWins,
    int? nb,
    int? perfomance,
    int? puzzleRatingAvg,
    int? replayWins,
  }) = _LichessPuzzleResult;

  factory LichessPuzzleResult.fromJson(Map<String, dynamic> json) =>
      _$LichessPuzzleResultFromJson(json);
}

@freezed
class LichessPuzzleTheme with _$LichessPuzzleTheme {
  const factory LichessPuzzleTheme({
    LichessPuzzleResult? results,
    String? theme,
  }) = _LichessPuzzleTheme;

  factory LichessPuzzleTheme.fromJson(Map<String, dynamic> json) =>
      _$LichessPuzzleThemeFromJson(json);
}

@freezed
class LichessPuzzleDashboard with _$LichessPuzzleDashboard {
  const factory LichessPuzzleDashboard({
    Map<String, LichessPuzzleTheme>? themes,
  }) = _LichessPuzzleDashboard;

  factory LichessPuzzleDashboard.fromJson(Map<String, dynamic> json) =>
      _$LichessPuzzleDashboardFromJson(json);
}
