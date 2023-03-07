import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.g.dart';
part 'models.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    final String? id,
    final String? username,
    final int? createdAt,
    final bool? disabled,
    final bool? tosViolation,
    final Profile? profile,
    final int? seenAt,
    final bool? patron,
    final bool? verified,
    final String? title,
    final String? url,
    final String? playing,
    final bool? streaming,
    final bool? followable,
    final bool? following,
    final bool? blocking,
    final bool? followsYou,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
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
    // TODO: Handle link line break.
    String? links,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}

@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    final bool? dark,
    final bool? transp,
    final String? bgImg,
    final bool? is3d,
    final Theme? theme,
    final PieceSet? pieceSet,
    final Theme3d? theme3d,
    final PieceSet3d? pieceSet3d,
    final SoundSet? soundSet,
    final int? blindfold,
    final int? autoQueen,
    final int? autoThreefold,
    final int? takeback,
    final int? moretime,
    final int? clockTenths,
    final bool? clockBar,
    final bool? clockSound,
    final bool? premove,
    final int? animation,
    final bool? captured,
    final bool? follow,
    final bool? highlight,
    final bool? destination,
    final int? coords,
    final int? replay,
    final int? challenge,
    final int? message,
    final int? coordColor,
    final int? submitMove,
    final int? confirmResign,
    final int? insightShare,
    final int? keyboardMove,
    final int? zen,
    final int? moveEvent,
    final int? rookCastle,
    final String? language,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}

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
