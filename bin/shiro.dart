import 'package:dotenv/dotenv.dart';
import 'package:shiro/shiro.dart';

Future<void> main(List<String> arguments) async {
  final DotEnv env = DotEnv()..load();

  final String? token = env['LICHESS_PERSONAL_TOKEN'];

  assert(
    token != null,
    'You need to define your personal token inside the file .env, use .env.example as template.',
  );

  final ShiroClient lichessClient = ShiroClient(accessToken: token);

  final User user = await lichessClient.getAccount();
  final String email = await lichessClient.getAccountEmail();
  final UserPreferences prefs = await lichessClient.getAccountPreferences();

  lichessClient.close();

  print(user);
  print(email);
  print(prefs);
}
