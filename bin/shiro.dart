import 'package:dio/dio.dart';
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
  final List<User> value = await shiro.autocompleteUsers(term: 'alexr');

  await shiro.close();

  print('user: $user');
  print('email: $email');
  print('prefs: $prefs');
  print('isKidMode: $isKidMode');
  print('publicUser: $publicUser');
  print('value: $value');
}
