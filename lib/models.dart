import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shirou/shirou.dart';

part 'models.g.dart';
part 'models.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    final String? id,
    final String? name,
    final String? username,
    final Perfs? perfs,
    final int? createdAt,
    final bool? disabled,
    final bool? tosViolation,
    final Profile? profile,
    final int? seenAt,
    final bool? patron,
    final bool? verified,
    final PlayTime? playTime,
    final Title? title,
    final String? url,
    final String? playing,
    final Count? count,
    final bool? streaming,
    final bool? followable,
    final bool? following,
    final bool? blocking,
    final bool? followsYou,
    final LiveStream? stream,
    final LiveStreamer? streamer,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class Count with _$Count {
  const factory Count({
    final int? all,
    final int? rated,
    final int? ai,
    final int? draw,
    final int? drawH,
    final int? loss,
    final int? lossH,
    final int? win,
    final int? winH,
    final int? bookmark,
    final int? playing,
    final int? import,
    final int? me,
  }) = _Count;

  factory Count.fromJson(Map<String, dynamic> json) => _$CountFromJson(json);
}

@freezed
class PlayTime with _$PlayTime {
  const factory PlayTime({
    final int? total,
    final int? tv,
  }) = _PlayTime;

  factory PlayTime.fromJson(Map<String, dynamic> json) =>
      _$PlayTimeFromJson(json);
}

@freezed
class RatingHistory with _$RatingHistory {
  const factory RatingHistory({
    final String? name,
    final List<List<int>>? points,
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
    final DateTime? date,
    final int? rating,
  }) = _RatingHistoryEntry;

  factory RatingHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$RatingHistoryEntryFromJson(json);
}

@freezed
class LiveStream with _$LiveStream {
  const factory LiveStream({
    final String? service,
    final String? status,
    final String? lang,
  }) = _LiveStream;

  factory LiveStream.fromJson(Map<String, dynamic> json) =>
      _$LiveStreamFromJson(json);
}

@freezed
class LiveStreamer with _$LiveStreamer {
  const factory LiveStreamer({
    final String? name,
    final String? headline,
    final String? description,
    final String? twitch,
    final String? youTube,
    final String? image,
  }) = _LiveStreamer;

  factory LiveStreamer.fromJson(Map<String, dynamic> json) =>
      _$LiveStreamerFromJson(json);
}

@freezed
class RealTimeUserStatus with _$RealTimeUserStatus {
  const factory RealTimeUserStatus({
    final String? id,
    final String? name,
    final String? title,
    final bool? online,
    final bool? playing,
    final bool? streaming,
    final bool? patron,
    final String? playingId,
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

@freezed
class Perf with _$Perf {
  const factory Perf({
    final int? games,
    final int? rating,
    final int? rd,
    final int? prog,
    final bool? prov,
  }) = _Perf;

  factory Perf.fromJson(Map<String, dynamic> json) => _$PerfFromJson(json);
}

@freezed
class StormPerf with _$StormPerf {
  const factory StormPerf({
    final int? runs,
    final int? score,
  }) = _StormPerf;

  factory StormPerf.fromJson(Map<String, dynamic> json) =>
      _$StormPerfFromJson(json);
}

@freezed
class Perfs with _$Perfs {
  const factory Perfs({
    final Perf? chess960,
    final Perf? atomic,
    final Perf? racingKings,
    final Perf? ultraBullet,
    final Perf? blitz,
    final Perf? kingOfTheHill,
    final Perf? bullet,
    final Perf? correspondence,
    final Perf? horde,
    final Perf? puzzle,
    final Perf? classical,
    final Perf? rapid,
    final StormPerf? storm,
  }) = _Perfs;

  factory Perfs.fromJson(Map<String, dynamic> json) => _$PerfsFromJson(json);
}

@freezed
class Team with _$Team {
  const factory Team({
    final String? id,
    final String? name,
    final String? description,
    final bool? open,
    final User? leader,
    final List<User>? leaders,
    final int? nbMembers,
    final String? location,
  }) = _Team;

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
}

@freezed
class TeamsPager with _$TeamsPager {
  const factory TeamsPager({
    final int? currentPage,
    final int? maxPerPage,
    final List<Team>? currentPageResults,
    final int? nbResults,
    final int? previousPage,
    final int? nextPage,
    final int? nbPages,
  }) = _TeamsPager;

  factory TeamsPager.fromJson(Map<String, dynamic> json) =>
      _$TeamsPagerFromJson(json);
}

@freezed
class TeamMember with _$TeamMember {
  const factory TeamMember({
    final String? id,
    final String? username,
    final Perfs? perfs,
    final int? createdAt,
    final bool? disabled,
    final bool? tosViolation,
    final Profile? profile,
    final int? seenAt,
    final bool? patron,
    final bool? verified,
    final PlayTime? playTime,
    final Title? title,
    final String? url,
    final String? playing,
    final Count? count,
    final bool? streaming,
    final bool? followable,
    final bool? following,
    final bool? blocking,
    final bool? followsYou,
  }) = _TeamMember;

  factory TeamMember.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberFromJson(json);
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
