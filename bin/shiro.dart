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

  final ShiroClient client = ShiroClient.create(accessToken: token);

  final User user = await client.getMyProfile();
  final String email = await client.getMyEmailAddress();
  final UserPreferences prefs = await client.getMyPreferences();
  final bool isKidMode = await client.getMyKidModeStatus();

  await client.close();

  print('user: $user');
  print('email: $email');
  print('prefs: $prefs');
  print('isKidMode: $isKidMode');
}
