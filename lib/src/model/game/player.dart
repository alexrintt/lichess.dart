import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common/models.dart';
import '../user/user.dart';

part 'player.freezed.dart';

@freezed
class Player with _$Player {
  const factory Player({
    UserId? id,
    required String name,
    int? rating,
    int? ratingDiff,
    bool? provisional,
    String? title,
    bool? patron,
    int? aiLevel,
  }) = _Player;

  const Player._();

  LightUser? get lightUser => id != null
      ? LightUser(
          id: id!,
          name: name,
          title: title,
          isPatron: patron,
        )
      : null;
}
