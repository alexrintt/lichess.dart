import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/models.dart';

part 'board.g.dart';
part 'board.freezed.dart';

/// Helper when the initial fen is not provided by the API.
const String kStandardChessInitialFen =
    'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

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

  final LichessBoardGameEventType type;
}

abstract class LichessBoardGameIncomingEvent {
  const LichessBoardGameIncomingEvent({required this.type});

  final LichessBoardGameIncomingEventType type;
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
class LichessGameStartEvent
    with _$LichessGameStartEvent
    implements LichessBoardGameIncomingEvent {
  const factory LichessGameStartEvent({
    required LichessBoardGameIncomingEventType type,
    required LichessGameEventInfo game,
  }) = _LichessGameStartEvent;

  factory LichessGameStartEvent.fromJson(Map<String, dynamic> json) =>
      _$LichessGameStartEventFromJson(json);
}

/// https://lichess.org/api#tag/Board
@freezed
class LichessGameFinishEvent
    with _$LichessGameFinishEvent
    implements LichessBoardGameIncomingEvent {
  const factory LichessGameFinishEvent({
    required LichessBoardGameIncomingEventType type,
    required LichessGameEventInfo game,
  }) = _LichessGameFinishEvent;

  factory LichessGameFinishEvent.fromJson(Map<String, dynamic> json) =>
      _$LichessGameFinishEventFromJson(json);
}

/// https://lichess.org/api#tag/Board
@freezed
class LichessGameEventInfo with _$LichessGameEventInfo {
  const factory LichessGameEventInfo({
    String? id,
    LichessGameEventSource? source,
    LichessGameEventCompat? compat,
  }) = _LichessGameEventInfo;

  factory LichessGameEventInfo.fromJson(Map<String, dynamic> json) =>
      _$LichessGameEventInfoFromJson(json);
}

/// https://lichess.org/api#tag/Board
@freezed
class LichessGameChallengeEvent with _$LichessGameChallengeEvent {
  const factory LichessGameChallengeEvent({
    required String id,
    required String url,
    required LichessChallengeStatus status,
    required LichessChallengeUser challenger,
    required LichessChallengeUser destUser,
    required LichessVariant variant,
    required bool rated,
    required LichessSpeed speed,
    required LichessGameClock timeControl,
    required LichessChallengeColor color,
    required LichessGameChallengePerf perf,
    LichessChallengeDirection? direction,
    String? initialFen,
    String? declineReason,
  }) = _LichessGameChallengeEvent;

  factory LichessGameChallengeEvent.fromJson(Map<String, dynamic> json) =>
      _$LichessGameChallengeEventFromJson(json);
}

/// https://lichess.org/api#tag/Board
@freezed
class LichessGameChallengePerf with _$LichessGameChallengePerf {
  const factory LichessGameChallengePerf({
    String? name,
    String? icon,
  }) = _LichessGameChallengePerf;

  factory LichessGameChallengePerf.fromJson(Map<String, dynamic> json) =>
      _$LichessGameChallengePerfFromJson(json);
}

/// https://lichess.org/api#tag/Board
@freezed
class LichessChallengeUser with _$LichessChallengeUser {
  const factory LichessChallengeUser({
    required String id,
    required String name,
    int? rating,
    bool? provisional,
    bool? online,
    Title? title,
    bool? patron,
  }) = _LichessChallengeUser;

  factory LichessChallengeUser.fromJson(Map<String, dynamic> json) =>
      _$LichessChallengeUserFromJson(json);
}

/// https://lichess.org/api#tag/Board
@freezed
class LichessGameEventCompat with _$LichessGameEventCompat {
  const factory LichessGameEventCompat({
    bool? bot,
    bool? board,
  }) = _LichessGameEventCompat;

  factory LichessGameEventCompat.fromJson(Map<String, dynamic> json) =>
      _$LichessGameEventCompatFromJson(json);
}

/// https://lichess.org/api#tag/Board
@freezed
class LichessGameFullEvent
    with _$LichessGameFullEvent
    implements LichessBoardGameEvent {
  const factory LichessGameFullEvent({
    required LichessBoardGameEventType type,
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
    required LichessBoardGameEventType type,
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
    required LichessBoardGameEventType type,
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
    required LichessBoardGameEventType type,
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
/// https://lichess.org/api#tag/Board
@freezed
class LichessGameClock with _$LichessGameClock {
  const factory LichessGameClock({
    int? initial,
    int? increment,
    int? totalTime,
    int? limit,
    int? daysPerTurn,
    String? show,
  }) = _LichessGameClock;

  factory LichessGameClock.fromJson(Map<String, dynamic> json) =>
      _$LichessGameClockFromJson(json);
}

/// https://lichess.org/api#tag/Board
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

  bool get isWhite => this == white;
  bool get isBlack => this == black;

  final String raw;
}

/// https://lichess.org/api#tag/TV/operation/tvFeed
@JsonEnum(valueField: 'raw')
enum LichessChallengeDirection {
  incoming('in'),
  outcoming('out');

  const LichessChallengeDirection(this.raw);

  final String raw;
}

/// https://lichess.org/api#tag/TV/operation/tvFeed
@JsonEnum(valueField: 'raw')
enum LichessChallengeColor {
  white('white'),
  black('black'),
  random('random');

  const LichessChallengeColor(this.raw);

  bool get isWhite => this == white;
  bool get isBlack => this == black;
  bool get isRandom => this == random;

  final String raw;
}

/// https://lichess.org/api#tag/TV/operation/tvFeed
@JsonEnum(valueField: 'raw')
enum LichessChallengeStatus {
  created('created'),
  offline('offline'),
  canceled('canceled'),
  declined('declined'),
  accepted('accepted');

  const LichessChallengeStatus(this.raw);

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
enum LichessBoardGameEventType {
  /// Then parse as [LichessOpponentGoneEvent].
  opponentGone('opponentGone'),

  /// Then parse as [LichessChatLineEvent].
  chatLine('chatLine'),

  /// Then parse as [LichessGameStateEvent].
  gameState('gameState'),

  /// Then parse as [LichessGameFullEvent].
  gameFull('gameFull');

  const LichessBoardGameEventType(this.raw);

  final String raw;
}

/// https://lichess.org/api#tag/Games/operation/apiGamesUser
@JsonEnum(valueField: 'raw')
enum LichessBoardGameIncomingEventType {
  gameStart('gameStart'),
  gameFinish('gameFinish'),
  challenge('challenge'),
  challengeCanceled('challengeCanceled'),
  challengeDeclined('challengeDeclined');

  const LichessBoardGameIncomingEventType(this.raw);

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

/// https://lichess.org/api#tag/Board/operation/apiStreamEvent
@JsonEnum(valueField: 'raw')
enum LichessGameEventSource {
  lobby('lobby'),
  friend('friend'),
  ai('ai'),
  api('api'),
  tournament('tournament'),
  position('position'),
  import('import'),
  importlive('importlive'),
  simul('simul'),
  relay('relay'),
  pool('pool'),
  swiss('swiss');

  const LichessGameEventSource(this.raw);

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
