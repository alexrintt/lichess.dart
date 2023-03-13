// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_RatingHistory _$$_RatingHistoryFromJson(Map<String, dynamic> json) =>
    _$_RatingHistory(
      name: json['name'] as String?,
      points: (json['points'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).map((e) => e as int).toList())
          .toList(),
    );

Map<String, dynamic> _$$_RatingHistoryToJson(_$_RatingHistory instance) =>
    <String, dynamic>{
      'name': instance.name,
      'points': instance.points,
    };

_$_RatingHistoryEntry _$$_RatingHistoryEntryFromJson(
        Map<String, dynamic> json) =>
    _$_RatingHistoryEntry(
      date: DateTime.parse(json['date'] as String),
      rating: json['rating'] as int,
    );

Map<String, dynamic> _$$_RatingHistoryEntryToJson(
        _$_RatingHistoryEntry instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'rating': instance.rating,
    };
