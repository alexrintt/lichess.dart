import 'dart:developer';

import 'package:dotenv/dotenv.dart';
import 'package:lichess_client/lichess_client.dart';

Future<void> main(List<String> arguments) async {
  final DotEnv env = DotEnv()..load();

  final String? token = env['LICHESS_PERSONAL_TOKEN'];

  assert(
    token != null,
    'You need to define your personal token inside the file .env, use .env.example as template.',
  );

  final LichessClient lichess = LichessClient.create(accessToken: token);

  final User user = await lichess.getMyProfile();
  final String email = await lichess.getMyEmailAddress();
  final UserPreferences prefs = await lichess.getMyPreferences();
  final bool isKidMode = await lichess.getMyKidModeStatus();
  final User publicUser =
      await lichess.getUserPublicData(username: 'alexrintt');
  final List<User> autoCompleteUsers =
      await lichess.autocompleteUsers(term: 'alexr');
  final List<String> autoCompleteUsernames =
      await lichess.autocompleteUsernames(term: 'alexr');
  final List<RatingHistory> ratingHistory =
      await lichess.getUserRatingHistory(username: 'riccardocescon');
  final List<RealTimeUserStatus> chessNetwork = await lichess
      .getRealTimeStatusOfSeveralUsers(ids: <String>['chess-network']);
  final List<User> severalUsers = await lichess
      .getSeveralUsersById(ids: <String>['alexrintt', 'riccardocescon']);
  final List<User> liveStreamers = await lichess.getLiveStreamers();
  final Team getTeam = await lichess.getTeam(teamId: 'group-test');
  final TeamsPager teamsPager = await lichess.getTeamsOnPage(page: 1);
  final List<Team> userTeams =
      await lichess.getUserTeams(username: 'riccardocescon');
  final TeamsPager searchTeams =
      await lichess.searchTeam(name: 'test', page: 1);
  final List<TeamMember> teamMembers =
      await lichess.getTeamMembers(teamId: 'group-test');
  final void joinTeam = await lichess.joinTeam(teamId: 'group-test');
  final void leaveTeam = await lichess.leaveTeam(teamId: 'group-test');
  final List<JoinRequest> joinRequests =
      await lichess.getJoinRequests(teamId: 'simple-app-test');

  // Commented because there are requests
  // final void acceptJoinRequest = await lichess.acceptJoinRequest(
  //   teamId: 'simple-app-test',
  //   userId: 'alexrintt',
  // );
  // final void declineJoinRequest = await lichess.declineJoinRequest(
  //   teamId: 'simple-app-test',
  //   userId: 'alexrintt',
  // );
  final void kickUser = await lichess.kickUserFromTeam(
    teamId: 'simple-app-test',
    userId: 'alexrintt',
  );
  final void messageToAllMembers = await lichess.messageAllMembers(
    teamId: 'simple-app-test',
    message: 'Hello world!',
  );

  await lichess.close();

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
  log('joinRequests: $joinRequests\n\n');
}
