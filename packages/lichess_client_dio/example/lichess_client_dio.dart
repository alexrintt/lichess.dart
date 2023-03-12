import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:lichess_client_dio/lichess_client_dio.dart';

Future<void> main(List<String> arguments) async {
  final DotEnv env = DotEnv()..load();

  final String? token = env['LICHESS_PERSONAL_TOKEN'];

  assert(
    token != null,
    'You need to define your personal token inside the file .env, use .env.example as template.',
  );

  final LichessClient lichess = LichessClientDio.create(accessToken: token);

  await _displayLoggedUserEmail(lichess);
  await _displayLoggedUserProfile(lichess);
  await _displayLoggedUserPreferences(lichess);
  await _displayLoggedUserFollows(lichess);
  await _displayLoggedUserKidModeStatus(lichess);
  await _toggleAndDisplayLoggedUserKidModeStatus(lichess);
  await _displayLiveStreamers(lichess);
  await _fetchAndDisplaySeveralUsers(lichess);
  await _fetchAndDisplayRealTimeStatusOfSeveralUsers(lichess);
  await _displayAutocompleteUsernameResultsFor('alexr', lichess);
  await _displayAutocompleteUserResultsFor('alexr', lichess);
  await _displayRatingHistoryOf('riccardocescon', lichess);
  await _displayUserPublicData('riccardocescon', lichess);
  await _displayTeamInfo('group-test', lichess);
  await _displayMostPopularTeams(lichess);
  await _displayUserTeams('riccardocescon', lichess);
  await _displayTeamSearchResultsFor('test', lichess);
  await _displayTeamMembers('lichess-swiss', lichess);

  // TODO: lichess.teams.join
  // TODO: lichess.teams.leave
  // TODO: lichess.teams.getJoinRequests
  // TODO: lichess.teams.kickMember

  await lichess.close();
}

Future<void> _displayTeamMembers(
  String teamId,
  LichessClient lichess,
) async {
  _header('lichess.teams.getMembers');

  // Even some teams having more than 300k users, the Lichess API does not support pagination for this endpoint (!)
  // https://github.com/lichess-org/lila/issues/12502
  //
  // We do not recommend setting the limit >= 60 because the Lichess currently has a rate-limit of 20 members per second.
  // So setting a limit >= 60 means you request will be at minimum 3 seconds longer (taking off delay or slow connections).
  //
  // https://github.com/lichess-org/lila/blob/14980251a2c39339ac4c0df2bf53c2f2e0047e10/app/controllers/Team.scala#L126.
  final List<User> members = await lichess.teams.getMembers(teamId: teamId);

  _footer('First ${members.length} members of $teamId');

  _print('Response members count: ${members.length}');
  _print('Members: ${members.map((User member) => member.id).join(', ')}');

  _footer('lichess.teams.getMembers');
}

Future<void> _displayTeamSearchResultsFor(
  String text,
  LichessClient lichess,
) async {
  _header('lichess.teams.getByUser');
  final PageOf<Team> query = await lichess.teams.search(text: text);

  _footer('Search results for $text:');

  _footer('Query info');

  _print('query.currentPage: ${query.currentPage}');
  _print('query.maxPerPage: ${query.maxPerPage}');
  _print('query.nbPages: ${query.nbPages}');
  _print('query.nbResults: ${query.nbResults}');
  _print('query.nextPage: ${query.nextPage}');
  _print('query.previousPage: ${query.previousPage}');

  _footer('End query info');

  for (final Team team in query.currentPageResults ?? <Team>[]) {
    _footer('Start team entry');
    _printTeamInfo(team);
    _footer('End of entry');
  }

  _footer('lichess.teams.getByUser');
}

Future<void> _displayUserTeams(String username, LichessClient lichess) async {
  _header('lichess.teams.getByUser');
  final List<Team> userTeams =
      await lichess.teams.getByUser(username: username);

  _footer('Teams that $username is member of:');

  for (final Team team in userTeams) {
    _printTeamInfo(team);
    _footer('End of entry');
  }

  _footer('lichess.teams.getByUser');
}

void _printTeamInfo(Team team) {
  _print('Team id: ${team.id}');
  _print('Team name: ${team.name}');
  _print('Team description: ${team.description}');
  _print('Team leader: ${team.leader?.id}');
  _print('Number of members: ${team.nbMembers}');
  _print('Location: ${team.location}');
  _print('Is team open? ${team.open}');
}

Future<void> _displayTeamInfo(String teamId, LichessClient lichess) async {
  _header('lichess.teams.getById');
  final Team team = await lichess.teams.getById(teamId);

  _printTeamInfo(team);

  _footer('lichess.teams.getById');
}

Future<void> _displayMostPopularTeams(LichessClient lichess) async {
  _header('lichess.teams.getPopular');

  // you can also do pagination by providing [page] param.
  final PageOf<Team> mostPopularTeams = await lichess.teams.getPopular();

  for (final Team team in mostPopularTeams.currentPageResults ?? <Team>[]) {
    _printTeamInfo(team);
    _footer('End of entry');
  }

  _footer('lichess.teams.getPopular');
}

Future<void> _displayUserPublicData(
  String username,
  LichessClient lichess,
) async {
  _header('lichess.users.getPublicData');
  final User user = await lichess.users.getPublicData(username: username);
  _print('Public data of $username: $user');
  _footer('lichess.users.getPublicData');
}

Future<void> _displayRatingHistoryOf(
  String username,
  LichessClient lichess,
) async {
  final List<RatingHistory> ratingHistory =
      await lichess.users.getRatingHistory(username: username);

  _header('lichess.users.getRatingHistory');

  for (final RatingHistory ratingHistory in ratingHistory) {
    _footer('${ratingHistory.name ?? 'Unnamed category'} stats for $username');

    if (ratingHistory.info == null) {
      _print('No data is available $username');
    } else if (ratingHistory.info!.isEmpty) {
      _print('Not enough data for $username');
    } else {
      final RatingHistoryEntry newest = ratingHistory.info!.newest;
      final RatingHistoryEntry older = ratingHistory.info!.oldest;

      final RatingHistoryEntry highest = ratingHistory.info!.highest;
      final RatingHistoryEntry lowest = ratingHistory.info!.lowest;

      final int ratingDelta = newest.rating - older.rating;
      final Duration timeDelta = Duration(
        milliseconds: newest.date.millisecondsSinceEpoch -
            older.date.millisecondsSinceEpoch,
      );

      _print('Current rating: ${newest.rating}');
      _print('Highest rating: ${highest.rating}');
      _print('Lowest rating: ${lowest.rating}');
      _print('Rating delta: $ratingDelta');
      _print('Account life time in days: ${timeDelta.inDays}');
    }

    _footer(ratingHistory.name ?? 'Unnamed category');
  }

  _footer('lichess.users.getRatingHistory');
}

Future<void> _displayAutocompleteUsernameResultsFor(
  String username,
  LichessClient lichess,
) async {
  final List<String> results =
      await lichess.users.autocompleteUsernames(term: 'alexr');

  _header('lichess.users.autocompleteUsernames');
  _print(
    'Autocomplete results for [$username]: ${results.map((String e) => e).join(', ')}',
  );
  _footer('lichess.users.autocompleteUsernames');
}

Future<void> _displayAutocompleteUserResultsFor(
  String username,
  LichessClient lichess,
) async {
  final List<User> results = await lichess.users.autocomplete(term: 'alexr');

  _header('lichess.users.autocomplete');
  _print(
    'Autocomplete object results for [$username]: ${results.map((User e) => '${e.id} (object)').join(', ')}',
  );
  _footer('lichess.users.autocomplete');
}

Future<void> _fetchAndDisplayRealTimeStatusOfSeveralUsers(
  LichessClient lichess,
) async {
  final List<RealTimeUserStatus> users = await lichess.users.getRealTimeStatus(
    ids: <String>['chess-network', 'alexrintt', 'riccardocescon'],
  );

  _header('lichess.users.getRealTimeStatus');
  _print(
    'Fetched users: ${users.map((RealTimeUserStatus e) => '${e.name} (${e.online ? 'Online' : 'Offline'})').join(', ')}',
  );
  _footer('lichess.users.getRealTimeStatus');
}

Future<void> _fetchAndDisplaySeveralUsers(LichessClient lichess) async {
  final List<User> users = await lichess.users
      .getManyById(ids: <String>['alexrintt', 'riccardocescon']);

  _header('lichess.users.getManyById');
  _print(
    'Fetched users: ${users.map((User e) => '${e.id} (${e.url})').join(', ')}',
  );
  _footer('lichess.users.getManyById');
}

Future<void> _displayLiveStreamers(LichessClient lichess) async {
  final List<User> liveStreamers = await lichess.users.getLiveStreamers();

  _header('lichess.users.getLiveStreamers');
  _print(
    'Live streamers: ${liveStreamers.map((User e) => '${e.id} (${e.url})').join(', ')}',
  );
  _footer('lichess.users.getLiveStreamers');
}

Future<void> _displayLoggedUserKidModeStatus(LichessClient lichess) async {
  final bool isKidMode = await lichess.account.getKidModeStatus();
  _header('lichess.account.getKidModeStatus');
  _print('isKidMode: $isKidMode');
  _footer('lichess.account.getKidModeStatus');
}

Future<void> _toggleAndDisplayLoggedUserKidModeStatus(
  LichessClient lichess,
) async {
  _header('lichess.account.setMyKidModeStatus');
  _print('Toggling kid mode status...');

  bool isKidMode = await lichess.account.getKidModeStatus();
  await lichess.account.setMyKidModeStatus(enableKidMode: !isKidMode);
  isKidMode = await lichess.account.getKidModeStatus();

  _print('New kid mode status: $isKidMode');
  _footer('lichess.account.getMyKidModeStatus');
}

Future<void> _displayLoggedUserPreferences(LichessClient lichess) async {
  final UserPreferences preferences = await lichess.account.getMyPreferences();
  _header('lichess.account.getMyPreferences');
  _print('Preference: $preferences');
  _footer('lichess.account.getMyPreferences');
}

Future<void> _displayLoggedUserEmail(LichessClient lichess) async {
  final String email = await lichess.account.getEmailAddress();
  _header('lichess.account.getMyEmailAddress');
  _print('My email address is: $email');
  _footer('lichess.account.getMyEmailAddress');
}

Future<void> _displayLoggedUserProfile(LichessClient lichess) async {
  final User user = await lichess.account.getProfile();
  _header('lichess.account.getMyProfile');
  _print('My ID is: ${user.id}');
  _print('Bio: ${user.profile?.bio}');
  _print(
    'My account was created at: ${DateTime.fromMillisecondsSinceEpoch(user.createdAt!)}',
  );
  _footer('lichess.account.getMyProfile');
}

Future<void> _displayLoggedUserFollows(LichessClient lichess) async {
  _header('lichess.relations.getFollowing');
  final List<User> follows = await lichess.relations.getFollowing();
  _print(
    'Logged user follows: ${follows.map((User e) => e.id).join(', ')}',
  );
  _footer('lichess.relations.getFollowing');
}

bool _first = true;

void _header(String message) {
  stdout.writeln('${_first ? '' : '\n\n'}${'-' * 10} [$message] ${'-' * 10}');
  _first = false;
}

void _footer(String message) {
  stdout.writeln('${'-' * 10} [$message] ${'-' * 10}');
}

void _print(String message) {
  stdout.writeln(message);
}
