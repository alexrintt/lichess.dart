import 'package:dotenv/dotenv.dart';
import 'package:shiro/shiro.dart';

Future<void> main(List<String> arguments) async {
  final DotEnv env = DotEnv()..load();

  final String? token = env['LICHESS_PERSONAL_TOKEN'];

  assert(
    token != null,
    'You need to define your personal token inside the file .env, use .env.example as template.',
  );

  final ShiroClient shiro = ShiroClient.create(accessToken: token);

  final User user = await shiro.getMyProfile();
  final String email = await shiro.getMyEmailAddress();
  final UserPreferences prefs = await shiro.getMyPreferences();
  final bool isKidMode = await shiro.getMyKidModeStatus();
  final User publicUser = await shiro.getUserPublicData(username: 'alexrintt');
  final List<User> autoCompleteUsers =
      await shiro.autocompleteUsers(term: 'alexr');
  final List<String> autoCompleteUsernames =
      await shiro.autocompleteUsernames(term: 'alexr');
  final List<RatingHistory> ratingHistory =
      await shiro.getUserRatingHistory(username: 'riccardocescon');
  final List<RealTimeUserStatus> chessNetwork =
      await shiro.getRealTimeStatusOfSeveralUsers(ids: ['chess-network']);
  final List<User> severalUsers =
      await shiro.getSeveralUsersById(ids: ['alexrintt', 'riccardocescon']);
  final List<User> liveStreamers = await shiro.getLiveStreamers();

  await shiro.close();

  print('user: $user\n\n');
  print('email: $email\n\n');
  print('prefs: $prefs\n\n');
  print('isKidMode: $isKidMode\n\n');
  print('publicUser: $publicUser\n\n');
  print('autoCompleteUsers: $autoCompleteUsers\n\n');
  print('autoCompleteUsernames: $autoCompleteUsernames\n\n');
  print('ratingHistory: $ratingHistory\n\n');
  print('chessNetwork: $chessNetwork\n\n');
  print('severalUsers: $severalUsers\n\n');
  print('liveStreamers: $liveStreamers\n\n');
}
