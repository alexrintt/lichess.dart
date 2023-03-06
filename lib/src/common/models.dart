import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

part 'models.freezed.dart';
part 'models.g.dart';

/// Move represented with UCI notation
typedef UCIMove = String;

/// Represents a [Move] with its associated SAN.
@Freezed(fromJson: true, toJson: true)
class SanMove with _$SanMove {
  const factory SanMove(
    String san,
    @JsonKey(fromJson: _moveFromJson, toJson: _moveToJson) Move move,
  ) = _SanMove;

  factory SanMove.fromJson(Map<String, dynamic> json) =>
      _$SanMoveFromJson(json);
}

String _moveToJson(Move move) => move.uci;
// assume we are serializing only valid uci strings
Move _moveFromJson(String uci) => Move.fromUci(uci)!;

/// A pair of time and increment used as game clock
@immutable
class TimeIncrement {
  const TimeIncrement(this.time, this.increment);

  /// Clock initial time in minutes
  final int time;

  /// Clock increment in seconds
  final int increment;

  static TimeIncrement? fromString(String str) {
    try {
      final nums = str.split('+').map(int.parse).toList();
      return TimeIncrement(nums.first, nums[1]);
    } catch (_) {
      return null;
    }
  }

  TimeIncrement.fromJson(Map<String, dynamic> json)
      : time = json['time'] as int,
        increment = json['increment'] as int;

  Map<String, dynamic> toJson() => {
        'time': time,
        'increment': increment,
      };

  String get display => '$time + $increment';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeIncrement &&
          runtimeType == other.runtimeType &&
          time == other.time &&
          increment == other.increment;

  @override
  int get hashCode => Object.hash(time, increment);

  @override
  String toString() => '$time+$increment';
}

@Freezed(fromJson: true, toJson: true, toStringOverride: false)
class GameAnyId with _$GameAnyId {
  const GameAnyId._();

  const factory GameAnyId(String value) = _GameAnyId;

  GameId get gameId => GameId(value.substring(0, 8));
  bool get isFullId => value.length == 12;
  GameFullId? get gameFullId => isFullId ? GameFullId(value) : null;

  factory GameAnyId.fromJson(Map<String, dynamic> json) =>
      _$GameAnyIdFromJson(json);

  @override
  String toString() => value;
}

@Freezed(fromJson: true, toJson: true, toStringOverride: false)
class GameId with _$GameId {
  const GameId._();

  @Assert('value.length == 8')
  const factory GameId(String value) = _GameId;

  factory GameId.fromJson(Map<String, dynamic> json) => _$GameIdFromJson(json);

  @override
  String toString() => value;
}

@Freezed(fromJson: true, toJson: true, toStringOverride: false)
class GameFullId with _$GameFullId {
  const GameFullId._();

  @Assert('value.length == 12')
  const factory GameFullId(String value) = _GameFullId;

  factory GameFullId.fromJson(Map<String, dynamic> json) =>
      _$GameFullIdFromJson(json);

  @override
  String toString() => value;
}

@Freezed(fromJson: true, toJson: true, toStringOverride: false)
class GamePlayerId with _$GamePlayerId {
  const GamePlayerId._();

  @Assert('value.length == 4')
  const factory GamePlayerId(String value) = _GamePlayerId;

  factory GamePlayerId.fromJson(Map<String, dynamic> json) =>
      _$GamePlayerIdFromJson(json);

  @override
  String toString() => value;
}

@Freezed(fromJson: true, toJson: true, toStringOverride: false)
class PuzzleId with _$PuzzleId {
  const PuzzleId._();

  const factory PuzzleId(String value) = _PuzzleId;

  factory PuzzleId.fromJson(Map<String, dynamic> json) =>
      _$PuzzleIdFromJson(json);

  @override
  String toString() => value;
}

@Freezed(fromJson: true, toJson: true, toStringOverride: false)
class UserId with _$UserId {
  const UserId._();

  const factory UserId(String value) = _UserId;

  factory UserId.fromJson(Map<String, dynamic> json) => _$UserIdFromJson(json);

  factory UserId.fromUserName(String userName) =>
      UserId(userName.toLowerCase());

  @override
  String toString() => value;
}

/// Represents a lichess rating perf item
enum Perf {
  ultraBullet('UltraBullet', 'Ultra'),
  bullet('Bullet', 'Bullet'),
  blitz('Blitz', 'Blitz'),
  rapid('Rapid', 'Rapid'),
  classical('Classical', 'Classical'),
  correspondence('Correspondence', 'Corresp.'),
  chess960('Chess 960', '960'),
  antichess('Antichess', 'Antichess'),
  kingOfTheHill('King Of The Hill', 'KotH'),
  threeCheck('Three-check', '3check'),
  atomic('Atomic', 'Atomic'),
  horde('Horde', 'Horde'),
  racingKings('Racing Kings', 'Racing'),
  crazyhouse('Crazyhouse', 'Crazy'),
  puzzle('Puzzle', 'Puzzle'),
  storm('Storm', 'Storm');

  const Perf(this.title, this.shortTitle);

  final String title;
  final String shortTitle;
}
