import 'package:freezed_annotation/freezed_annotation.dart';
import '../user/user.dart';

part 'user_session.freezed.dart';

@Freezed(fromJson: true, toJson: true)
class UserSession with _$UserSession {
  const factory UserSession({
    required LightUser user,
    required String token,
  }) = _UserSession;

  factory UserSession.fromJson(Map<String, dynamic> json) =>
      _$UserSessionFromJson(json);
}
