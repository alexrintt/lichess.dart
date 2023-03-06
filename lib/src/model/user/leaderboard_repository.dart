import 'package:logging/logging.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:riverpod/riverpod.dart';
import 'package:shiro/src/common/api_client.dart';
import 'package:shiro/src/constants.dart';
import 'package:shiro/src/model/user/leaderboard.dart';

import '../../extensions/future_result.dart';
import '../../utils/json.dart';

class LeaderboardRepository {
  const LeaderboardRepository({required this.apiClient, required Logger logger})
      : _log = logger;

  final ApiClient apiClient;
  final Logger _log;

  FutureResult<Leaderboard> getLeaderboard() {
    return apiClient
        .get(Uri.parse('$kLichessHost/api/player'))
        .flatMap((response) {
      return readJsonObject(
        response.body,
        mapper: _leaderboardFromJson,
        logger: _log,
      );
    });
  }

  void dispose() => apiClient.close();
}

Leaderboard _leaderboardFromJson(Map<String, dynamic> json) =>
    _leaderBoardFromPick(pick(json).required());

Leaderboard _leaderBoardFromPick(RequiredPick pick) {
  return Leaderboard(
    bullet: pick('bullet').asListOrEmpty(_leaderboardUserFromPick),
    blitz: pick('blitz').asListOrEmpty(_leaderboardUserFromPick),
    rapid: pick('rapid').asListOrEmpty(_leaderboardUserFromPick),
    classical: pick('classical').asListOrEmpty(_leaderboardUserFromPick),
    ultrabullet: pick('ultraBullet').asListOrEmpty(_leaderboardUserFromPick),
    crazyhouse: pick('crazyhouse').asListOrEmpty(_leaderboardUserFromPick),
    chess960: pick('chess960').asListOrEmpty(_leaderboardUserFromPick),
    kingOfThehill:
        pick('kingOfTheHill').asListOrEmpty(_leaderboardUserFromPick),
    threeCheck: pick('threeCheck').asListOrEmpty(_leaderboardUserFromPick),
    antichess: pick('antichess').asListOrEmpty(_leaderboardUserFromPick),
    atomic: pick('atomic').asListOrEmpty(_leaderboardUserFromPick),
    horde: pick('horde').asListOrEmpty(_leaderboardUserFromPick),
    racingKings: pick('racingKings').asListOrEmpty(_leaderboardUserFromPick),
  );
}

LeaderboardUser _leaderboardUserFromPick(RequiredPick pick) {
  final prefMap = pick('perfs').asMapOrThrow<String, Map<String, dynamic>>();

  return LeaderboardUser(
    id: pick('id').asUserIdOrThrow(),
    username: pick('username').asStringOrThrow(),
    title: pick('title').asStringOrNull(),
    patron: pick('patron').asBoolOrNull(),
    online: pick('online').asBoolOrNull(),
    rating: pick('perfs')
        .letOrThrow((perfsPick) => perfsPick(prefMap.keys.first, 'rating'))
        .asIntOrThrow(),
    progress: pick('perfs')
        .letOrThrow(
          (prefsPick) => prefsPick(prefMap.keys.first, 'progress'),
        )
        .asIntOrThrow(),
  );
}
