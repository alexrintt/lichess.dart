import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/models.dart';

part 'tv.g.dart';
part 'tv.freezed.dart';

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
    LichessColor? orientation,
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
