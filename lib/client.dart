import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shiro/models.dart';

class ShiroAuth {}

Map<String, dynamic> parseRawResponseToMap(dynamic raw) {
  return Map<String, Object>.from(raw as Map<dynamic, dynamic>);
}

Map<String, dynamic> parseBodyStringToMap(String body) {
  return parseRawResponseToMap(jsonDecode(body));
}

class ShiroClient {
  static final Uri kLichessBaseUri = Uri.parse('https://lichess.org');

  ShiroClient({
    this.accessToken,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  final http.Client httpClient;

  final String? accessToken;

  /// Whether or not [this] client can perform authenticated requests.
  bool get isLogged => accessToken != null;

  Map<String, String> get _authHeader => <String, String>{
        'Authorization': 'Bearer $accessToken',
      };

  /// Public information about the logged in user.
  Future<User> getAccount() async {
    _throwUnauthExceptionIfAccessTokenIsNotDefined();

    final Uri accountEndpoint =
        kLichessBaseUri.replace(pathSegments: <String>['api', 'account']);

    final http.Response response =
        await httpClient.get(accountEndpoint, headers: _authHeader);

    return User.fromJson(parseBodyStringToMap(response.body));
  }

  /// Read the email address of the logged in user.
  Future<String> getAccountEmail() async {
    _throwUnauthExceptionIfAccessTokenIsNotDefined();

    final Uri accountEmailEndpoint = kLichessBaseUri
        .replace(pathSegments: <String>['api', 'account', 'email']);

    final http.Response response =
        await httpClient.get(accountEmailEndpoint, headers: _authHeader);

    return parseBodyStringToMap(response.body)['email'] as String;
  }

  /// Read the preferences of the logged in user.
  ///
  /// - https://lichess.org/account/preferences/game-display.
  /// - https://github.com/ornicar/lila/blob/master/modules/pref/src/main/Pref.scala.
  Future<UserPreferences> getAccountPreferences() async {
    _throwUnauthExceptionIfAccessTokenIsNotDefined();

    final Uri accountEmailEndpoint = kLichessBaseUri
        .replace(pathSegments: <String>['api', 'account', 'preferences']);

    final http.Response response =
        await httpClient.get(accountEmailEndpoint, headers: _authHeader);

    final Map<String, dynamic> raw = parseBodyStringToMap(response.body);

    // Merge [prefs] fields and [language] from /account/preferences response.
    final Map<String, Object?> complete = <String, Object?>{
      ...Map<String, Object>.from(raw['prefs'] as Map<dynamic, dynamic>),
      'language': raw['language'] as String?,
    };

    return UserPreferences.fromJson(complete);
  }

  void _throwUnauthExceptionIfAccessTokenIsNotDefined() {
    if (!isLogged) {
      throw const LichessUnauthenticatedException();
    }
  }

  /// Closes the client and cleans up any resources associated with it.
  ///
  /// It's important to close each client when it's done being used; failing to do so can cause the Dart process to hang.
  Future<void> close() async => httpClient.close();
}

class LichessException implements Exception {
  const LichessException(this.message, [this.code]);

  final String message;
  final String? code;
}

class LichessUnauthenticatedException extends LichessException {
  const LichessUnauthenticatedException()
      : super(
          'You are trying to access an authenticated resource without an access token.',
          'LichessUnauthenticatedException',
        );
}

class NotImplementedError extends Error {}
