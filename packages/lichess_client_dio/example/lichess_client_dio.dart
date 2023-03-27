import 'dart:async';
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
  await _displayTeamMembersUsingBackpressure('lichess-swiss', lichess);
  await _displayCurrentTvGames(lichess);
  await _startStreamingTheCurrentTvGameForTheNextFewMoves(lichess);
  await _getGameModeLeaderboard(
    <PerfType>[
      PerfType.rapid,
      PerfType.atomic,
      PerfType.blitz,
      PerfType.bullet,
    ],
    lichess,
  );
  await _displayUserRecentGames('riccardocescon', lichess);
  await _displayInfoFromArbitraryGame('E1sx21nN', lichess);

  // TODO: lichess.teams.join
  // TODO: lichess.teams.leave
  // TODO: lichess.teams.getJoinRequests
  // TODO: lichess.teams.kickMember

  await lichess.close();
}

Future<void> _delay(int seconds) async {
  return Future<void>.delayed(Duration(seconds: seconds));
}

Future<void> _startStreamingTheCurrentTvGameForTheNextFewMoves(
  LichessClient lichess, {
  int movesCount = 10,
}) async {
  _header('lichess.tv.streamCurrentTvGame');

  final Stream<LichessTvGameSummary> currentTvGameStream =
      lichess.tv.streamCurrentTvGame().take(movesCount);

  bool first = true;

  await for (final LichessTvGameSummary tvGameSnapshot in currentTvGameStream) {
    if (first) {
      first = false;
      _print('Black: ${tvGameSnapshot.data?.blackPlayer?.user?.id}');
      _print('White: ${tvGameSnapshot.data?.whitePlayer?.user?.id}');
    }

    _print('Current game FEN: ${tvGameSnapshot.data?.fen}');
    _print('Orientation: ${tvGameSnapshot.data?.orientation}');
  }

  _footer('lichess.tv.streamCurrentTvGame');
}

Future<void> _displayInfoFromArbitraryGame(
  String gameId,
  LichessClient lichess,
) async {
  _header('lichess.games.exportGame');

  final LichessGame game = await lichess.games.exportGame(gameId: gameId);

  _footer(
    '${game.players.black?.user?.id} (Black) vs ${game.players.white?.user?.id} (White)',
  );
  _print('Speed: ${game.speed}');
  _print('Perf type: ${game.perf}');
  _print('Initial fen: ${game.initialFen}');
  _print('Moves: ${game.moves}');
  _print('Winner: ${game.winner?.raw}');
  _print('Rated: ${game.rated}');
  _print('Status: ${game.status}');
  _print('Game Id: ${game.id}');
  _print('Clock: ${game.clock}');

  _footer('lichess.games.exportGame');
}

Future<void> _displayUserRecentGames(
  String username,
  LichessClient lichess,
) async {
  _header('lichess.games.exportGamesOfUser');

  final Stream<LichessGame> userGames =
      lichess.games.exportGamesOfUser(username: username, max: 10);

  await for (final LichessGame game in userGames) {
    _footer(
      '${game.players.black?.user?.id} (Black) vs ${game.players.white?.user?.id} (White)',
    );
    _print('Speed: ${game.speed}');
    _print('Perf type: ${game.perf}');
    _print('Initial fen: ${game.initialFen}');
    _print('Moves: ${game.moves}');
    _print('Winner: ${game.winner?.raw}');
    _print('Rated: ${game.rated}');
    _print('Status: ${game.status}');
    _print('Game Id: ${game.id}');
    _print('Clock: ${game.clock}');
  }

  _footer('lichess.games.exportGamesOfUser');
}

Future<void> _displayCurrentTvGames(LichessClient lichess) async {
  _header('lichess.tv.getCurrentTvGames');

  final List<LichessTvGameBasicInfo> tvGames =
      await lichess.tv.getCurrentTvGames();

  for (final LichessTvGameBasicInfo tvGameBasicInfo in tvGames) {
    _footer('Channel: ${tvGameBasicInfo.channel}');
    _print('user.name: ${tvGameBasicInfo.user?.name}');
    _print('user.id: ${tvGameBasicInfo.user?.id}');
    _print('user.patron: ${tvGameBasicInfo.user?.patron}');
    _print('user.title: ${tvGameBasicInfo.user?.title}');
    _print('game rating: ${tvGameBasicInfo.rating}');
    _print('game id: ${tvGameBasicInfo.gameId}');
  }

  _footer('lichess.tv.getCurrentTvGames');
}

Future<void> _displayTeamMembersUsingBackpressure(
  String teamId,
  LichessClient lichess,
) async {
  late final StreamSubscription<User> subscription;
  late final Stream<User> teamMembersStream;

  _header('lichess.teams.getMembers');

  teamMembersStream = lichess.teams.getMembers(teamId: teamId);

  _print('Members: ');

  final Completer<void> completer = Completer<void>();

  final List<User> users = <User>[];

  Future<void> cancel() async {
    _print('Canceling subscription...');
    await subscription.cancel();
    completer.complete();
  }

  subscription = teamMembersStream.listen(
    (User user) async {
      users.add(user);

      _print('${user.id} (name: ${user.name})');

      if (users.length % 20 == 0) {
        if (users.length >= 30) {
          _print('Got 60th user loaded, stopping...');
          // When we reach the 60th user loaded, stop.
          await cancel();
        } else {
          _print('Pausing for 10 secs...');
          // When user list reaches the 20|40th user loaded, pause for 10 seconds.
          subscription.pause();
          await _delay(10);
          _print('Resuming again...');
          subscription.resume();
        }
      }
    },
    onDone: cancel,
    cancelOnError: true,
    onError: (Object error, StackTrace stackTrace) {
      _print('Error $error');
      _print('Stack trace: $stackTrace');
      cancel();
    },
  );

  await completer.future;

  _footer('lichess.teams.getMembers');
}

Future<void> _displayTeamMembers(
  String teamId,
  LichessClient lichess,
) async {
  _header('lichess.teams.getMembers');

  final Stream<User> teamMembersStream =
      lichess.teams.getMembers(teamId: teamId);

  final List<User> members = await teamMembersStream.take(30).toList();

  _footer('First ${members.length} members of $teamId');

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

Future<void> _getGameModeLeaderboard(
  List<PerfType> perfTypes,
  LichessClient lichess,
) async {
  _header('lichess.users.getPerfTypeLeaderboard');

  for (final PerfType perfType in perfTypes) {
    _footer('$perfType');

    final List<User> users =
        await lichess.users.getPerfTypeLeaderboard(perfType: perfType);

    int i = 0;

    for (final User user in users) {
      _print('${++i}th: ${user.id}');
    }
  }

  _footer('lichess.users.getPerfTypeLeaderboard');
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
      await lichess.users.searchNamesByTerm(term: 'alexr');

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
  final List<User> results = await lichess.users.searchByTerm(term: 'alexr');

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
