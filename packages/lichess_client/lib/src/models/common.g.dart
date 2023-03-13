// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Count _$$_CountFromJson(Map<String, dynamic> json) => _$_Count(
      all: json['all'] as int?,
      rated: json['rated'] as int?,
      ai: json['ai'] as int?,
      draw: json['draw'] as int?,
      drawH: json['drawH'] as int?,
      loss: json['loss'] as int?,
      lossH: json['lossH'] as int?,
      win: json['win'] as int?,
      winH: json['winH'] as int?,
      bookmark: json['bookmark'] as int?,
      playing: json['playing'] as int?,
      import: json['import'] as int?,
      me: json['me'] as int?,
    );

Map<String, dynamic> _$$_CountToJson(_$_Count instance) => <String, dynamic>{
      'all': instance.all,
      'rated': instance.rated,
      'ai': instance.ai,
      'draw': instance.draw,
      'drawH': instance.drawH,
      'loss': instance.loss,
      'lossH': instance.lossH,
      'win': instance.win,
      'winH': instance.winH,
      'bookmark': instance.bookmark,
      'playing': instance.playing,
      'import': instance.import,
      'me': instance.me,
    };

_$_PlayTime _$$_PlayTimeFromJson(Map<String, dynamic> json) => _$_PlayTime(
      total: json['total'] as int?,
      tv: json['tv'] as int?,
    );

Map<String, dynamic> _$$_PlayTimeToJson(_$_PlayTime instance) =>
    <String, dynamic>{
      'total': instance.total,
      'tv': instance.tv,
    };

_$_Perf _$$_PerfFromJson(Map<String, dynamic> json) => _$_Perf(
      games: json['games'] as int?,
      rating: json['rating'] as int?,
      rd: json['rd'] as int?,
      prog: json['prog'] as int?,
      prov: json['prov'] as bool?,
    );

Map<String, dynamic> _$$_PerfToJson(_$_Perf instance) => <String, dynamic>{
      'games': instance.games,
      'rating': instance.rating,
      'rd': instance.rd,
      'prog': instance.prog,
      'prov': instance.prov,
    };

_$_StormPerf _$$_StormPerfFromJson(Map<String, dynamic> json) => _$_StormPerf(
      runs: json['runs'] as int?,
      score: json['score'] as int?,
    );

Map<String, dynamic> _$$_StormPerfToJson(_$_StormPerf instance) =>
    <String, dynamic>{
      'runs': instance.runs,
      'score': instance.score,
    };

_$_Perfs _$$_PerfsFromJson(Map<String, dynamic> json) => _$_Perfs(
      chess960: json['chess960'] == null
          ? null
          : Perf.fromJson(json['chess960'] as Map<String, dynamic>),
      atomic: json['atomic'] == null
          ? null
          : Perf.fromJson(json['atomic'] as Map<String, dynamic>),
      racingKings: json['racingKings'] == null
          ? null
          : Perf.fromJson(json['racingKings'] as Map<String, dynamic>),
      ultraBullet: json['ultraBullet'] == null
          ? null
          : Perf.fromJson(json['ultraBullet'] as Map<String, dynamic>),
      blitz: json['blitz'] == null
          ? null
          : Perf.fromJson(json['blitz'] as Map<String, dynamic>),
      kingOfTheHill: json['kingOfTheHill'] == null
          ? null
          : Perf.fromJson(json['kingOfTheHill'] as Map<String, dynamic>),
      bullet: json['bullet'] == null
          ? null
          : Perf.fromJson(json['bullet'] as Map<String, dynamic>),
      correspondence: json['correspondence'] == null
          ? null
          : Perf.fromJson(json['correspondence'] as Map<String, dynamic>),
      horde: json['horde'] == null
          ? null
          : Perf.fromJson(json['horde'] as Map<String, dynamic>),
      puzzle: json['puzzle'] == null
          ? null
          : Perf.fromJson(json['puzzle'] as Map<String, dynamic>),
      classical: json['classical'] == null
          ? null
          : Perf.fromJson(json['classical'] as Map<String, dynamic>),
      rapid: json['rapid'] == null
          ? null
          : Perf.fromJson(json['rapid'] as Map<String, dynamic>),
      storm: json['storm'] == null
          ? null
          : StormPerf.fromJson(json['storm'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_PerfsToJson(_$_Perfs instance) => <String, dynamic>{
      'chess960': instance.chess960,
      'atomic': instance.atomic,
      'racingKings': instance.racingKings,
      'ultraBullet': instance.ultraBullet,
      'blitz': instance.blitz,
      'kingOfTheHill': instance.kingOfTheHill,
      'bullet': instance.bullet,
      'correspondence': instance.correspondence,
      'horde': instance.horde,
      'puzzle': instance.puzzle,
      'classical': instance.classical,
      'rapid': instance.rapid,
      'storm': instance.storm,
    };
