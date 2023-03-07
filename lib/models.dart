import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.g.dart';
part 'models.freezed.dart';

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
class Count with _$Count {
  const factory Count({
    int? all,
    int? rated,
    int? ai,
    int? draw,
    int? drawH,
    int? loss,
    int? lossH,
    int? win,
    int? winH,
    int? bookmark,
    int? playing,
    int? import,
    int? me,
  }) = _Count;

  factory Count.fromJson(Map<String, dynamic> json) => _$CountFromJson(json);
}

@freezed
class PlayTime with _$PlayTime {
  const factory PlayTime({
    int? total,
    int? tv,
  }) = _PlayTime;

  factory PlayTime.fromJson(Map<String, dynamic> json) =>
      _$PlayTimeFromJson(json);
}

@freezed
class RatingHistory with _$RatingHistory {
  const factory RatingHistory({
    String? name,
    List<List<int>>? points,
  }) = _RatingHistory;

  factory RatingHistory.fromJson(Map<String, dynamic> json) =>
      _$RatingHistoryFromJson(json);

  /// Alias for [this.parseRawPointsAsRatingHistoryEntries].
  List<RatingHistoryEntry>? entries() => parseRawPointsAsRatingHistoryEntries();

  /// The [RatingHistory] of user consists in a array of [points] that per se is already
  /// a [List] that represents the user rating at a point in the time.
  ///
  /// This function parses the each point `List<int>` to a data class that holds
  /// a [DateTime] and a [rating] following the Lichess API reference.
  ///
  /// https://lichess.org/api#tag/Users/operation/apiUserRatingHistory
  List<RatingHistoryEntry>? parseRawPointsAsRatingHistoryEntries() {
    return points?.map((List<int> point) {
      final int year = point[0];
      final int month = point[1];
      final int day = point[2];
      final int rating = point[3];

      return RatingHistoryEntry(
        date: DateTime.utc(year, month + 1, day),
        rating: rating,
      );
    }).toList();
  }
}

@freezed
class RatingHistoryEntry with _$RatingHistoryEntry {
  const factory RatingHistoryEntry({
    DateTime? date,
    int? rating,
  }) = _RatingHistoryEntry;

  factory RatingHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$RatingHistoryEntryFromJson(json);
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
    bool? online,
    bool? playing,
    bool? streaming,
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
    SoundSet? soundSet,
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

@freezed
class Perf with _$Perf {
  const factory Perf({
    int? games,
    int? rating,
    int? rd,
    int? prog,
    bool? prov,
  }) = _Perf;

  factory Perf.fromJson(Map<String, dynamic> json) => _$PerfFromJson(json);
}

@freezed
class StormPerf with _$StormPerf {
  const factory StormPerf({
    int? runs,
    int? score,
  }) = _StormPerf;

  factory StormPerf.fromJson(Map<String, dynamic> json) =>
      _$StormPerfFromJson(json);
}

@freezed
class Perfs with _$Perfs {
  const factory Perfs({
    Perf? chess960,
    Perf? atomic,
    Perf? racingKings,
    Perf? ultraBullet,
    Perf? blitz,
    Perf? kingOfTheHill,
    Perf? bullet,
    Perf? correspondence,
    Perf? horde,
    Perf? puzzle,
    Perf? classical,
    Perf? rapid,
    StormPerf? storm,
  }) = _Perfs;

  factory Perfs.fromJson(Map<String, dynamic> json) => _$PerfsFromJson(json);
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
