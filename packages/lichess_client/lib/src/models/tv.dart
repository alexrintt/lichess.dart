import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/models.dart';

part 'tv.g.dart';
part 'tv.freezed.dart';

/// Helper when the initial fen is not provided by the API.
const String kStandardChessInitialFen =
    'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

/// https://lichess.org/api#tag/TV/operation/tvChannels
@freezed
class LichessTvGameBasicInfo with _$LichessTvGameBasicInfo {
  const factory LichessTvGameBasicInfo({
    TvChannel? channel,
    int? rating,
    String? gameId,
    User? user,
  }) = _LichessTvGameBasicInfo;

  factory LichessTvGameBasicInfo.fromJson(Map<String, dynamic> json) =>
      _$LichessTvGameBasicInfoFromJson(json);
}

/// https://lichess.org/api#tag/Games/operation/apiGamesUser
@freezed
class LichessTvGameSummary with _$LichessTvGameSummary {
  const factory LichessTvGameSummary({
    @JsonKey(name: 't') String? type,
    @JsonKey(name: 'd') LichessTvGameSummaryData? data,
  }) = _LichessTvGameSummary;

  factory LichessTvGameSummary.fromJson(Map<String, dynamic> json) =>
      _$LichessTvGameSummaryFromJson(json);
}

/// https://lichess.org/api#tag/TV/operation/tvChannels
@freezed
class LichessTvGameSummaryData with _$LichessTvGameSummaryData {
  const factory LichessTvGameSummaryData({
    String? id,
    ChessColor? orientation,
    List<LichessGamePlayer>? players,
    String? fen,
  }) = _LichessTvGameSummaryData;

  const LichessTvGameSummaryData._();

  factory LichessTvGameSummaryData.fromJson(Map<String, dynamic> json) =>
      _$LichessTvGameSummaryDataFromJson(json);

  LichessGamePlayer? get whitePlayer =>
      players?.firstWhere((LichessGamePlayer e) => e.color?.isWhite ?? false);

  LichessGamePlayer? get blackPlayer =>
      players?.firstWhere((LichessGamePlayer e) => e.color?.isBlack ?? false);
}

/// https://lichess.org/api#tag/TV/operation/tvFeed
@freezed
class LichessGamePlayer with _$LichessGamePlayer {
  const factory LichessGamePlayer({
    ChessColor? color,
    User? user,
    int? rating,
    int? ratingDiff,
  }) = _LichessGamePlayer;

  factory LichessGamePlayer.fromJson(Map<String, dynamic> json) =>
      _$LichessGamePlayerFromJson(json);
}

/// https://lichess.org/api#tag/Board/operation/boardGameStream
@freezed
class LichessVariant with _$LichessVariant {
  const factory LichessVariant({
    required LichessVariantKey key,
    required String name,
    required String short,
  }) = _LichessVariant;

  factory LichessVariant.fromJson(Map<String, dynamic> json) =>
      _$LichessVariantFromJson(json);
}

/// https://lichess.org/api#tag/Games/operation/apiGamesUser
@freezed
class LichessGame with _$LichessGame {
  const factory LichessGame({
    required String id,
    required bool rated,
    required LichessVariantKey variant,
    required LichessSpeed speed,
    required PerfType perf,
    required int createdAt,
    required int lastMoveAt,
    required LichessGameStatus status,
    required LichessGamePlayers players,
    List<int>? clocks,
    String? initialFen,
    ChessColor? winner,
    LichessGameOpening? opening,
    String? moves,
    LichessGameClock? clock,
  }) = _LichessGame;

  factory LichessGame.fromJson(Map<String, dynamic> json) =>
      _$LichessGameFromJson(json);
}

abstract class LichessBoardGameEvent {
  const LichessBoardGameEvent({required this.type});

  final String type;
}

/// https://lichess.org/api#tag/Board
@freezed
class LichessGamePerf with _$LichessGamePerf {
  const factory LichessGamePerf({
    String? name,
  }) = _LichessGamePerf;

  factory LichessGamePerf.fromJson(Map<String, dynamic> json) =>
      _$LichessGamePerfFromJson(json);
}

/// https://lichess.org/api#tag/Board
@freezed
class LichessGameFullEvent
    with _$LichessGameFullEvent
    implements LichessBoardGameEvent {
  const factory LichessGameFullEvent({
    required String type,
    required String id,
    required LichessVariant variant,
    required LichessSpeed speed,
    required LichessGamePerf perf,
    required bool rated,
    required LichessGameEventPlayer white,
    required LichessGameEventPlayer black,
    required LichessGameStateEvent state,
    @JsonKey(name: 'createdAt') required int createdAtInMilliseconds,
    LichessGameClock? clock,
    @Default('startpos') String initialFen,
    String? tournamentId,
  }) = _LichessGameFullEvent;

  const LichessGameFullEvent._();

  factory LichessGameFullEvent.fromJson(Map<String, dynamic> json) =>
      _$LichessGameFullEventFromJson(json);

  DateTime get createdAt =>
      DateTime.fromMillisecondsSinceEpoch(createdAtInMilliseconds, isUtc: true);
}

/// https://lichess.org/api#tag/Board
@freezed
class LichessChatLineEvent
    with _$LichessChatLineEvent
    implements LichessBoardGameEvent {
  const factory LichessChatLineEvent({
    required String type,
    required LichessChatLineRoom room,
    required String username,
    required String text,
  }) = _LichessChatLineEvent;

  const LichessChatLineEvent._();

  factory LichessChatLineEvent.fromJson(Map<String, dynamic> json) =>
      _$LichessChatLineEventFromJson(json);
}

/// https://lichess.org/api#tag/Board
@freezed
class LichessOpponentGoneEvent
    with _$LichessOpponentGoneEvent
    implements LichessBoardGameEvent {
  const factory LichessOpponentGoneEvent({
    required String type,
    required bool gone,
    int? claimWinInSeconds,
  }) = _LichessOpponentGoneEvent;

  const LichessOpponentGoneEvent._();

  factory LichessOpponentGoneEvent.fromJson(Map<String, dynamic> json) =>
      _$LichessOpponentGoneEventFromJson(json);
}

/// https://lichess.org/api#tag/Board
@freezed
class LichessGameEventPlayer with _$LichessGameEventPlayer {
  const factory LichessGameEventPlayer({
    required int aiLevel,
    required String id,
    required String name,
    required int rating,
    required bool provisional,
    String? title,
  }) = _LichessGameEventPlayer;

  const LichessGameEventPlayer._();

  factory LichessGameEventPlayer.fromJson(Map<String, dynamic> json) =>
      _$LichessGameEventPlayerFromJson(json);
}

/// https://lichess.org/api#tag/Board
@freezed
class LichessGameStateEvent
    with _$LichessGameStateEvent
    implements LichessBoardGameEvent {
  const factory LichessGameStateEvent({
    required String type,
    required String moves,
    required int wtime,
    required int btime,
    required int winc,
    required int binc,
    required LichessGameStatus status,
    ChessColor? winner,
    bool? wdraw,
    bool? bdraw,
    bool? wtakeback,
    bool? btakeback,
  }) = _LichessGameStateEvent;

  factory LichessGameStateEvent.fromJson(Map<String, dynamic> json) =>
      _$LichessGameStateEventFromJson(json);
}

/// https://lichess.org/api#tag/TV/operation/tvFeed
@freezed
class LichessGamePlayers with _$LichessGamePlayers {
  const factory LichessGamePlayers({
    LichessGamePlayer? white,
    LichessGamePlayer? black,
  }) = _LichessGamePlayers;

  factory LichessGamePlayers.fromJson(Map<String, dynamic> json) =>
      _$LichessGamePlayersFromJson(json);
}

/// https://lichess.org/api#tag/TV/operation/tvFeed
@freezed
class LichessGameClock with _$LichessGameClock {
  const factory LichessGameClock({
    int? initial,
    int? increment,
    int? totalTime,
    int? limit,
  }) = _LichessGameClock;

  factory LichessGameClock.fromJson(Map<String, dynamic> json) =>
      _$LichessGameClockFromJson(json);
}

/// https://lichess.org/api#tag/TV/operation/tvFeed
@freezed
class LichessGameOpening with _$LichessGameOpening {
  const factory LichessGameOpening({
    String? eco,
    String? name,
    int? ply,
  }) = _LichessGameOpening;

  factory LichessGameOpening.fromJson(Map<String, dynamic> json) =>
      _$LichessGameOpeningFromJson(json);
}

/// https://lichess.org/api#tag/TV/operation/tvFeed
@JsonEnum(valueField: 'raw')
enum ChessColor {
  white('white'),
  black('black');

  const ChessColor(this.raw);

  bool get isWhite => this == ChessColor.white;
  bool get isBlack => this == ChessColor.black;

  final String raw;
}

/// https://lichess.org/api#tag/Games/operation/apiGamesUser
@JsonEnum(valueField: 'raw')
enum LichessGameSort {
  dateDesc('dateDesc'),
  dateAsc('dateAsc');

  const LichessGameSort(this.raw);

  final String raw;
}

/// https://lichess.org/api#tag/Games/operation/apiGamesUser
@JsonEnum(valueField: 'raw')
enum LichessChatLineRoom {
  player('player'),
  spectator('spectator');

  const LichessChatLineRoom(this.raw);

  final String raw;
}

/// https://lichess.org/api#tag/TV/operation/tvChannels
@JsonEnum(valueField: 'raw')
enum TvChannel {
  bot('Bot'),
  blitz('Blitz'),
  racingKings('Racing Kings'),
  ultraBullet('UltraBullet'),
  bullet('Bullet'),
  classical('Classical'),
  threeCheck('Three-check'),
  antichess('Antichess'),
  computer('Computer'),
  horde('Horde'),
  rapid('Rapid'),
  atomic('Atomic'),
  crazyhouse('Crazyhouse'),
  chess960('Chess960'),
  kingOfTheHill('King of the Hill'),
  topRated('Top Rated');

  const TvChannel(this.raw);

  static TvChannel? fromJson(String raw) =>
      $enumDecodeNullable(_$TvChannelEnumMap, raw);

  final String raw;
}

/// https://lichess.org/api#tag/TV/operation/tvChannels
@JsonEnum(valueField: 'raw')
enum LichessVariantKey {
  standard('standard'),
  chess960('chess960'),
  crazyhouse('crazyhouse'),
  antichess('antichess'),
  atomic('atomic'),
  horde('horde'),
  kingOfTheHill('kingOfTheHill'),
  racingKings('racingKings'),
  threeCheck('threeCheck'),
  fromPosition('fromPosition');

  const LichessVariantKey(this.raw);

  final String raw;
}

/// https://lichess.org/api#tag/TV/operation/tvChannels
@JsonEnum(valueField: 'raw')
enum LichessSpeed {
  ultraBullet('ultraBullet'),
  bullet('bullet'),
  blitz('blitz'),
  rapid('rapid'),
  classical('classical'),
  correspondence('correspondence');

  const LichessSpeed(this.raw);

  final String raw;
}

/// https://lichess.org/api#tag/TV/operation/tvChannels
@JsonEnum(valueField: 'raw')
enum LichessGameStatus {
  created('created'),
  started('started'),
  aborted('aborted'),
  mate('mate'),
  resign('resign'),
  stalemate('stalemate'),
  timeout('timeout'),
  draw('draw'),
  outoftime('outoftime'),
  cheat('cheat'),
  noStart('noStart'),
  unknownFinish('unknownFinish'),
  variantEnd('variantEnd');

  const LichessGameStatus(this.raw);

  final String raw;
}
