import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

class ShiroAuth {}

class ShiroClient {
  ShiroClient({
    this.accessToken,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  final http.Client httpClient;

  final String? accessToken;

  /// Whether or not [this] client can perform authenticated requests.
  bool get isLogged => accessToken != null;

  /// Public information about the logged in user.
  Future<User?> getMyProfile() async {
    throw NotImplementedError();
  }
}

class NotImplementedError extends Error {}

@JsonSerializable()
class User {}
