import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:shiro/models.dart';

part 'client.g.dart';

Map<String, dynamic> parseRawResponseToMap(dynamic raw) {
  return Map<String, Object>.from(raw as Map<dynamic, dynamic>);
}

Map<String, dynamic> parseBodyStringToMap(String body) {
  return parseRawResponseToMap(jsonDecode(body));
}

abstract class ShiroClient {
  /// Interface for this client, if you are looking for a concrete implementation
  /// use [ShiroClient.create] instead.
  const ShiroClient();

  factory ShiroClient.create({String? accessToken, Dio? dio, String? baseUrl}) =
      ShiroClientImpl;

  /// Whether or not [this] client can perform authenticated requests.
  bool get isLogged;

  /// Public information about the logged in user.
  Future<User> getMyProfile();

  /// Read the email address of the logged in user.
  Future<String> getMyEmailAddress();

  /// Read the preferences of the logged in user.
  ///
  /// - https://lichess.org/account/preferences/game-display.
  /// - https://github.com/ornicar/lila/blob/master/modules/pref/src/main/Pref.scala.
  Future<UserPreferences> getMyPreferences();
  Future<bool> getMyKidModeStatus();
  Future<void> setMyKidModeStatus({required bool enableKidMode});
  Future<void> close({bool force = false});
}

@RestApi(baseUrl: 'https://lichess.org/api')
abstract class ShiroClientImpl implements ShiroClient {
  factory ShiroClientImpl({String? accessToken, Dio? dio, String? baseUrl}) {
    final Dio dioClient = dio ?? Dio();

    if (accessToken != null) {
      dioClient.options.headers['Authorization'] = 'Bearer $accessToken';
    }

    final _ShiroClientImpl shiro = _ShiroClientImpl._(
      dioClient,
      dioClient,
      accessToken != null,
      baseUrl: baseUrl,
    );

    return shiro
      ..dio.options =
          dioClient.options.copyWith(baseUrl: baseUrl ?? shiro.baseUrl!);
  }

  ShiroClientImpl._({required this.dio, required this.hasAccessToken});

  final Dio dio;
  final bool hasAccessToken;

  @override
  bool get isLogged => hasAccessToken;

  @override
  @GET('/account')
  Future<User> getMyProfile();

  @override
  Future<String> getMyEmailAddress() async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>('/account/email');

    return response.data!['email'] as String;
  }

  @override
  Future<UserPreferences> getMyPreferences() async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>('/account/preferences');

    return UserPreferences.fromJson(
      <String, dynamic>{
        'language': response.data!['language'] as String,
        ...response.data!['prefs'] as Map<String, dynamic>,
      },
    );
  }

  @override
  Future<bool> getMyKidModeStatus() async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>('/account/kid');

    return response.data!['kid'] as bool;
  }

  @override
  @POST('/account/kid')
  Future<void> setMyKidModeStatus({@Query('v') required bool enableKidMode});

  @override
  Future<void> close({bool force = false}) async => dio.close(force: force);
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
