import 'package:freezed_annotation/freezed_annotation.dart';

part 'common.g.dart';
part 'common.freezed.dart';

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
