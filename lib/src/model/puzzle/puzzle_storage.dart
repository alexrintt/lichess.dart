import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'puzzle.dart';
import 'puzzle_theme.dart';

part 'puzzle_storage.freezed.dart';
part 'puzzle_storage.g.dart';

@Freezed(fromJson: true, toJson: true)
class PuzzleLocalData with _$PuzzleLocalData {
  const factory PuzzleLocalData({
    required IList<PuzzleSolution> solved,
    required IList<Puzzle> unsolved,
  }) = _PuzzleLocalData;

  factory PuzzleLocalData.fromJson(Map<String, dynamic> json) =>
      _$PuzzleLocalDataFromJson(json);
}
