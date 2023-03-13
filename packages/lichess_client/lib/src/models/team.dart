import 'package:freezed_annotation/freezed_annotation.dart';

import '../../lichess_client.dart';

part 'team.g.dart';
part 'team.freezed.dart';

/// https://lichess.org/api#tag/Teams/operation/teamShow
@freezed
class Team with _$Team {
  const factory Team({
    String? id,
    String? name,
    String? description,
    bool? open,
    User? leader,
    List<User>? leaders,
    int? nbMembers,
    String? location,
  }) = _Team;

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
}

/// https://lichess.org/api#tag/Teams/operation/teamRequests
@freezed
class JoinRequest with _$JoinRequest {
  const factory JoinRequest({
    String? teamId,
    String? userId,
    User? user,
    int? date,
    String? message,
  }) = _JoinRequest;

  factory JoinRequest.fromJson(Map<String, dynamic> json) =>
      _$JoinRequestFromJson(json);
}
