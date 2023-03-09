import 'dart:developer';

import 'package:dotenv/dotenv.dart';
import 'package:shirou/shirou.dart';

Future<void> main(List<String> arguments) async {
  final DotEnv env = DotEnv()..load();

  final String? token = env['LICHESS_PERSONAL_TOKEN'];

  assert(
    token != null,
    'You need to define your personal token inside the file .env, use .env.example as template.',
  );

  final ShirouClient shirou = ShirouClient.create(accessToken: token);

  final User user = await shirou.getMyProfile();
  final String email = await shirou.getMyEmailAddress();
  final UserPreferences prefs = await shirou.getMyPreferences();
  final bool isKidMode = await shirou.getMyKidModeStatus();
  final User publicUser = await shirou.getUserPublicData(username: 'alexrintt');
  final List<User> autoCompleteUsers =
      await shirou.autocompleteUsers(term: 'alexr');
  final List<String> autoCompleteUsernames =
      await shirou.autocompleteUsernames(term: 'alexr');
  final List<RatingHistory> ratingHistory =
      await shirou.getUserRatingHistory(username: 'riccardocescon');
  final List<RealTimeUserStatus> chessNetwork = await shirou
      .getRealTimeStatusOfSeveralUsers(ids: <String>['chess-network']);
  final List<User> severalUsers = await shirou
      .getSeveralUsersById(ids: <String>['alexrintt', 'riccardocescon']);
  final List<User> liveStreamers = await shirou.getLiveStreamers();
  final Team getTeam = await shirou.getTeam(teamId: 'group-test');
  final TeamsPager teamsPager = await shirou.getTeamsOnPage(page: 1);
  final List<Team> userTeams =
      await shirou.getUserTeams(username: 'riccardocescon');
  final TeamsPager searchTeams = await shirou.searchTeam(name: 'test', page: 1);
  final List<TeamMember> teamMembers =
      await shirou.getTeamMembers(teamId: 'group-test');

  final joinTeam = await shirou.joinTeam(teamId: 'group-test');

  await shirou.close();

  log('user: $user\n\n');
  log('email: $email\n\n');
  log('prefs: $prefs\n\n');
  log('isKidMode: $isKidMode\n\n');
  log('publicUser: $publicUser\n\n');
  log('autoCompleteUsers: $autoCompleteUsers\n\n');
  log('autoCompleteUsernames: $autoCompleteUsernames\n\n');
  log('ratingHistory: $ratingHistory\n\n');
  log('chessNetwork: $chessNetwork\n\n');
  log('severalUsers: $severalUsers\n\n');
  log('liveStreamers: $liveStreamers\n\n');
  log('getTeam: $getTeam\n\n');
  log('teamsPager: $teamsPager\n\n');
  log('userTeams: $userTeams\n\n');
  log('searchTeams: $searchTeams\n\n');
  log('teamMembers: $teamMembers\n\n');
  // log('joinTeam: $joinTeam\n\n');
}
