import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/models.dart';

part 'tv.g.dart';
part 'tv.freezed.dart';

/// https://lichess.org/api#tag/TV/operation/tvChannels
@freezed
class TvGameBasicInfo with _$TvGameBasicInfo {
  const factory TvGameBasicInfo({
    TvChannel? channel,
    int? rating,
    String? gameId,
    User? user,
  }) = _TvGameBasicInfo;

  factory TvGameBasicInfo.fromJson(Map<String, dynamic> json) =>
      _$TvGameBasicInfoFromJson(json);
}

/// https://lichess.org/api#tag/TV/operation/tvFeed
@freezed
class TvGameSummary with _$TvGameSummary {
  const factory TvGameSummary({
    @JsonKey(name: 't') String? type,
    @JsonKey(name: 'd') TvGameSummaryData? data,
  }) = _TvGameSummary;

  factory TvGameSummary.fromJson(Map<String, dynamic> json) =>
      _$TvGameSummaryFromJson(json);
}

/// https://lichess.org/api#tag/TV/operation/tvFeed
@freezed
class TvGameSummaryData with _$TvGameSummaryData {
  const factory TvGameSummaryData({
    String? id,
    ChessColor? orientation,
    List<TvGamePlayer>? players,
    String? fen,
  }) = _TvGameSummaryData;

  const TvGameSummaryData._();

  factory TvGameSummaryData.fromJson(Map<String, dynamic> json) =>
      _$TvGameSummaryDataFromJson(json);

  TvGamePlayer? get whitePlayer =>
      players?.firstWhere((TvGamePlayer e) => e.color?.isWhite ?? false);

  TvGamePlayer? get blackPlayer =>
      players?.firstWhere((TvGamePlayer e) => e.color?.isBlack ?? false);
}

/// https://lichess.org/api#tag/TV/operation/tvFeed
@freezed
class TvGamePlayer with _$TvGamePlayer {
  const factory TvGamePlayer({
    ChessColor? color,
    User? user,
    int? rating,
    int? ratingDiff,
  }) = _TvGamePlayer;

  factory TvGamePlayer.fromJson(Map<String, dynamic> json) =>
      _$TvGamePlayerFromJson(json);
}

/// https://lichess.org/api#tag/TV/operation/tvFeed
@freezed
class TvGame with _$TvGame {
  const factory TvGame({
    required String id,
    required bool rated,
    required LichessVariant variant,
    required ChessSpeed speed,
    required String perf,
    required int createdAt,
    required int lastMoveAt,
    required LichessGameStatus status,
    required TvGamePlayers players,
    String? initialFen,
    ChessColor? winner,
    TvGameOpening? opening,
    String? moves,
    TvGameClock? clock,
  }) = _TvGame;

  factory TvGame.fromJson(Map<String, dynamic> json) => _$TvGameFromJson(json);
}

/// https://lichess.org/api#tag/TV/operation/tvFeed
@freezed
class TvGamePlayers with _$TvGamePlayers {
  const factory TvGamePlayers({
    TvGamePlayer? white,
    TvGamePlayer? black,
  }) = _TvGamePlayers;

  factory TvGamePlayers.fromJson(Map<String, dynamic> json) =>
      _$TvGamePlayersFromJson(json);
}

/// https://lichess.org/api#tag/TV/operation/tvFeed
@freezed
class TvGameClock with _$TvGameClock {
  const factory TvGameClock({
    int? initial,
    int? increment,
    int? totalTime,
  }) = _TvGameClock;

  factory TvGameClock.fromJson(Map<String, dynamic> json) =>
      _$TvGameClockFromJson(json);
}

/// https://lichess.org/api#tag/TV/operation/tvFeed
@freezed
class TvGameOpening with _$TvGameOpening {
  const factory TvGameOpening({
    String? eco,
    String? name,
    int? ply,
  }) = _TvGameOpening;

  factory TvGameOpening.fromJson(Map<String, dynamic> json) =>
      _$TvGameOpeningFromJson(json);
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
enum LichessVariant {
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

  const LichessVariant(this.raw);

  final String raw;
}

/// https://lichess.org/api#tag/TV/operation/tvChannels
@JsonEnum(valueField: 'raw')
enum ChessSpeed {
  ultraBullet('ultraBullet'),
  bullet('bullet'),
  blitz('blitz'),
  rapid('rapid'),
  classical('classical'),
  correspondence('correspondence');

  const ChessSpeed(this.raw);

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
