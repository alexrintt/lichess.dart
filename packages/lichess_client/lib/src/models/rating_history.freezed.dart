// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rating_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RatingHistory _$RatingHistoryFromJson(Map<String, dynamic> json) {
  return _RatingHistory.fromJson(json);
}

/// @nodoc
mixin _$RatingHistory {
  String? get name => throw _privateConstructorUsedError;
  List<List<int>>? get points => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RatingHistoryCopyWith<RatingHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RatingHistoryCopyWith<$Res> {
  factory $RatingHistoryCopyWith(
          RatingHistory value, $Res Function(RatingHistory) then) =
      _$RatingHistoryCopyWithImpl<$Res, RatingHistory>;
  @useResult
  $Res call({String? name, List<List<int>>? points});
}

/// @nodoc
class _$RatingHistoryCopyWithImpl<$Res, $Val extends RatingHistory>
    implements $RatingHistoryCopyWith<$Res> {
  _$RatingHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? points = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      points: freezed == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as List<List<int>>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RatingHistoryCopyWith<$Res>
    implements $RatingHistoryCopyWith<$Res> {
  factory _$$_RatingHistoryCopyWith(
          _$_RatingHistory value, $Res Function(_$_RatingHistory) then) =
      __$$_RatingHistoryCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, List<List<int>>? points});
}

/// @nodoc
class __$$_RatingHistoryCopyWithImpl<$Res>
    extends _$RatingHistoryCopyWithImpl<$Res, _$_RatingHistory>
    implements _$$_RatingHistoryCopyWith<$Res> {
  __$$_RatingHistoryCopyWithImpl(
      _$_RatingHistory _value, $Res Function(_$_RatingHistory) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? points = freezed,
  }) {
    return _then(_$_RatingHistory(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      points: freezed == points
          ? _value._points
          : points // ignore: cast_nullable_to_non_nullable
              as List<List<int>>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_RatingHistory extends _RatingHistory {
  const _$_RatingHistory({this.name, final List<List<int>>? points})
      : _points = points,
        super._();

  factory _$_RatingHistory.fromJson(Map<String, dynamic> json) =>
      _$$_RatingHistoryFromJson(json);

  @override
  final String? name;
  final List<List<int>>? _points;
  @override
  List<List<int>>? get points {
    final value = _points;
    if (value == null) return null;
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'RatingHistory(name: $name, points: $points)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RatingHistory &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._points, _points));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(_points));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RatingHistoryCopyWith<_$_RatingHistory> get copyWith =>
      __$$_RatingHistoryCopyWithImpl<_$_RatingHistory>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RatingHistoryToJson(
      this,
    );
  }
}

abstract class _RatingHistory extends RatingHistory {
  const factory _RatingHistory(
      {final String? name, final List<List<int>>? points}) = _$_RatingHistory;
  const _RatingHistory._() : super._();

  factory _RatingHistory.fromJson(Map<String, dynamic> json) =
      _$_RatingHistory.fromJson;

  @override
  String? get name;
  @override
  List<List<int>>? get points;
  @override
  @JsonKey(ignore: true)
  _$$_RatingHistoryCopyWith<_$_RatingHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

RatingHistoryEntry _$RatingHistoryEntryFromJson(Map<String, dynamic> json) {
  return _RatingHistoryEntry.fromJson(json);
}

/// @nodoc
mixin _$RatingHistoryEntry {
  DateTime get date => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RatingHistoryEntryCopyWith<RatingHistoryEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RatingHistoryEntryCopyWith<$Res> {
  factory $RatingHistoryEntryCopyWith(
          RatingHistoryEntry value, $Res Function(RatingHistoryEntry) then) =
      _$RatingHistoryEntryCopyWithImpl<$Res, RatingHistoryEntry>;
  @useResult
  $Res call({DateTime date, int rating});
}

/// @nodoc
class _$RatingHistoryEntryCopyWithImpl<$Res, $Val extends RatingHistoryEntry>
    implements $RatingHistoryEntryCopyWith<$Res> {
  _$RatingHistoryEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? rating = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RatingHistoryEntryCopyWith<$Res>
    implements $RatingHistoryEntryCopyWith<$Res> {
  factory _$$_RatingHistoryEntryCopyWith(_$_RatingHistoryEntry value,
          $Res Function(_$_RatingHistoryEntry) then) =
      __$$_RatingHistoryEntryCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, int rating});
}

/// @nodoc
class __$$_RatingHistoryEntryCopyWithImpl<$Res>
    extends _$RatingHistoryEntryCopyWithImpl<$Res, _$_RatingHistoryEntry>
    implements _$$_RatingHistoryEntryCopyWith<$Res> {
  __$$_RatingHistoryEntryCopyWithImpl(
      _$_RatingHistoryEntry _value, $Res Function(_$_RatingHistoryEntry) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? rating = null,
  }) {
    return _then(_$_RatingHistoryEntry(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_RatingHistoryEntry implements _RatingHistoryEntry {
  const _$_RatingHistoryEntry({required this.date, required this.rating});

  factory _$_RatingHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$$_RatingHistoryEntryFromJson(json);

  @override
  final DateTime date;
  @override
  final int rating;

  @override
  String toString() {
    return 'RatingHistoryEntry(date: $date, rating: $rating)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RatingHistoryEntry &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.rating, rating) || other.rating == rating));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, date, rating);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RatingHistoryEntryCopyWith<_$_RatingHistoryEntry> get copyWith =>
      __$$_RatingHistoryEntryCopyWithImpl<_$_RatingHistoryEntry>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RatingHistoryEntryToJson(
      this,
    );
  }
}

abstract class _RatingHistoryEntry implements RatingHistoryEntry {
  const factory _RatingHistoryEntry(
      {required final DateTime date,
      required final int rating}) = _$_RatingHistoryEntry;

  factory _RatingHistoryEntry.fromJson(Map<String, dynamic> json) =
      _$_RatingHistoryEntry.fromJson;

  @override
  DateTime get date;
  @override
  int get rating;
  @override
  @JsonKey(ignore: true)
  _$$_RatingHistoryEntryCopyWith<_$_RatingHistoryEntry> get copyWith =>
      throw _privateConstructorUsedError;
}
