import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/models.dart';

part 'user.g.dart';
part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    String? id,
    String? name,
    String? username,
    Perfs? perfs,
    int? createdAt,
    bool? disabled,
    bool? tosViolation,
    Profile? profile,
    int? seenAt,
    bool? patron,
    bool? verified,
    PlayTime? playTime,
    Title? title,
    String? url,
    String? playing,
    Count? count,
    bool? streaming,
    bool? followable,
    bool? following,
    bool? blocking,
    bool? followsYou,
    LiveStream? stream,
    LiveStreamer? streamer,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class LiveStream with _$LiveStream {
  const factory LiveStream({
    String? service,
    String? status,
    String? lang,
  }) = _LiveStream;

  factory LiveStream.fromJson(Map<String, dynamic> json) =>
      _$LiveStreamFromJson(json);
}

@freezed
class LiveStreamer with _$LiveStreamer {
  const factory LiveStreamer({
    String? name,
    String? headline,
    String? description,
    String? twitch,
    String? youTube,
    String? image,
  }) = _LiveStreamer;

  factory LiveStreamer.fromJson(Map<String, dynamic> json) =>
      _$LiveStreamerFromJson(json);
}

@freezed
class RealTimeUserStatus with _$RealTimeUserStatus {
  const factory RealTimeUserStatus({
    String? id,
    String? name,
    String? title,
    // The Lichess API does not return false for these fields when they are not on.
    // They are just omitted from the server response. So the default value is [false] instead of [null].
    @Default(false) bool online,
    @Default(false) bool playing,
    @Default(false) bool streaming,
    bool? patron,
    String? playingId,
  }) = _RealTimeUserStatus;

  factory RealTimeUserStatus.fromJson(Map<String, dynamic> json) =>
      _$RealTimeUserStatusFromJson(json);
}

@freezed
class Profile with _$Profile {
  const factory Profile({
    String? country,
    String? location,
    String? bio,
    String? firstName,
    String? lastName,
    int? fideRating,
    int? uscfRating,
    int? ecfRating,
    String? links,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}

@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    bool? dark,
    bool? transp,
    String? bgImg,
    bool? is3d,
    Theme? theme,
    PieceSet? pieceSet,
    Theme3d? theme3d,
    PieceSet3d? pieceSet3d,
    String? soundSet,
    int? blindfold,
    int? autoQueen,
    int? autoThreefold,
    int? takeback,
    int? moretime,
    int? clockTenths,
    bool? clockBar,
    bool? clockSound,
    bool? premove,
    int? animation,
    bool? captured,
    bool? follow,
    bool? highlight,
    bool? destination,
    int? coords,
    int? replay,
    int? challenge,
    int? message,
    int? coordColor,
    int? submitMove,
    int? confirmResign,
    int? insightShare,
    int? keyboardMove,
    int? zen,
    int? moveEvent,
    int? rookCastle,
    String? language,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}

@JsonEnum(valueField: 'raw')
enum PerfType {
  ultraBullet('ultraBullet'),
  bullet('bullet'),
  blitz('blitz'),
  rapid('rapid'),
  classical('classical'),
  chess960('chess960'),
  crazyhouse('crazyhouse'),
  antichess('antichess'),
  atomic('atomic'),
  horde('horde'),
  kingOfTheHill('kingOfTheHill'),
  racingKings('racingKings'),
  threeCheck('threeCheck');

  const PerfType(this.raw);

  final String raw;
}

@JsonEnum(valueField: 'raw')
enum Title {
  gm('GM'),
  wgm('WGM'),
  im('IM'),
  wim('WIM'),
  fm('FM'),
  wfm('WFM'),
  nm('NM'),
  cm('CM'),
  wcm('WCM'),
  wnm('WNM'),
  lm('LM'),
  bot('BOT');

  const Title(this.raw);

  final String raw;
}

/// The library exposes this enum but we do not use it.
///
/// The reason is this issue: https://github.com/lichess-org/api/issues/233.
///
/// For now we can not use since it will imply that the API call deserialization
/// will fail until the user sets the [SoundSet] pref manually.
///
/// So, let package user handle it himself, although we expose a helper method [tryParseIgnoringCase].
@JsonEnum(valueField: 'raw')
enum SoundSet {
  silent('silent'),
  standard('standard'),
  piano('piano'),
  nes('nes'),
  sfx('sfx'),
  futuristic('futuristic'),
  robot('robot'),
  music('music'),
  speech('speech');

  const SoundSet(this.raw);

  final String raw;

  /// Try parse the [soundSet] Lichess preference string ignoring the case.
  ///
  /// See this issue for details: https://github.com/lichess-org/api/issues/233.
  static SoundSet? tryParseIgnoringCase(String raw) {
    final int index = SoundSet.values.indexWhere(
      (SoundSet e) => e.raw.toLowerCase() == raw.toLowerCase(),
    );

    if (index == -1) {
      return null;
    }

    return SoundSet.values[index];
  }
}

@JsonEnum(valueField: 'raw')
enum PieceSet3d {
  basic('Basic'),
  wood('Wood'),
  metal('Metal'),
  redVBlue('RedVBlue'),
  modernJade('ModernJade'),
  modernWood('ModernWood'),
  glass('Glass'),
  trimmed('Trimmed'),
  experimental('Experimental'),
  staunton('Staunton'),
  cubesAndPi('CubesAndPi');

  const PieceSet3d(this.raw);

  final String raw;
}

@JsonEnum(valueField: 'raw')
enum Theme3d {
  blackWhiteAluminium('Black-White-Aluminium'),
  brushedAluminium('Brushed-Aluminium'),
  chinaBlue('China-Blue'),
  chinaGreen('China-Green'),
  chinaGrey('China-Grey'),
  chinaScarlet('China-Scarlet'),
  classicBlue('Classic-Blue'),
  goldSilver('Gold-Silver'),
  lightWood('Light-Wood'),
  powerCoated('Power-Coated'),
  rosewood('Rosewood'),
  marble('Marble'),
  wax('Wax'),
  jade('Jade'),
  woodi('Woodi');

  const Theme3d(this.raw);

  final String raw;
}

@JsonEnum(valueField: 'raw')
enum PieceSet {
  cburnett('cburnett'),
  merida('merida'),
  alpha('alpha'),
  pirouetti('pirouetti'),
  chessnut('chessnut'),
  chess7('chess7'),
  reillycraig('reillycraig'),
  companion('companion'),
  riohacha('riohacha'),
  kosal('kosal'),
  leipzig('leipzig'),
  fantasy('fantasy'),
  spatial('spatial'),
  california('california'),
  pixel('pixel'),
  maestro('maestro'),
  fresca('fresca'),
  cardinal('cardinal'),
  gioco('gioco'),
  tatiana('tatiana'),
  staunty('staunty'),
  governor('governor'),
  dubrovny('dubrovny'),
  icpieces('icpieces'),
  shapes('shapes'),
  letter('letter');

  const PieceSet(this.raw);

  final String raw;
}

@JsonEnum(valueField: 'raw')
enum Theme {
  blue('blue'),
  blue2('blue2'),
  blue3('blue3'),
  blueMarble('blue-marble'),
  canvas('canvas'),
  wood('wood'),
  wood2('wood2'),
  wood3('wood3'),
  wood4('wood4'),
  maple('maple'),
  maple2('maple2'),
  brown('brown'),
  leather('leather'),
  green('green'),
  marble('marble'),
  greenPlastic('green-plastic'),
  grey('grey'),
  metal('metal'),
  olive('olive'),
  newspaper('newspaper'),
  purple('purple'),
  purpleDiag('purple-diag'),
  pink('pink'),
  ic('ic');

  const Theme(this.raw);

  final String raw;
}
