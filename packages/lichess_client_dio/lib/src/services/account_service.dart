import 'package:dio/dio.dart';
import 'package:lichess_client/lichess_client.dart';
import 'package:retrofit/http.dart';

import '../utils/create_dio_client_with.dart';

part 'account_service.g.dart';

/// {@template account}
/// Read and write account information and preferences. https://lichess.org/account/preferences/game-display.
///
/// https://lichess.org/api#tag/Account
/// {@endtemplate}
@RestApi()
abstract class AccountServiceDio implements AccountService {
  factory AccountServiceDio(Dio dio) => _AccountServiceDio._(dio, dio);

  factory AccountServiceDio.create({
    String? accessToken,
    String baseUrl = 'https://lichess.org',
  }) =>
      AccountServiceDio(
        createLichessDioClientWith(accessToken: accessToken, baseUrl: baseUrl),
      );

  // To allow methods use [dio] instance.
  const AccountServiceDio._({required this.dio});

  /// Dio client linked with this service instance.
  final Dio dio;

  /// Public information about the logged in user.
  ///
  /// https://lichess.org/api#tag/Account/operation/accountMe
  @override
  @GET('/api/account')
  Future<User> getProfile();

  /// Read the email address of the logged in user.
  ///
  /// https://lichess.org/api#tag/Account/operation/accountEmail
  @override
  Future<String> getEmailAddress() async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>('/api/account/email');

    return response.data!['email'] as String;
  }

  /// Read the preferences of the logged in user.
  ///
  /// - https://lichess.org/account/preferences/game-display.
  /// - https://github.com/ornicar/lila/blob/master/modules/pref/src/main/Pref.scala.
  ///
  /// https://lichess.org/api#tag/Account/operation/account
  @override
  Future<UserPreferences> getMyPreferences() async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>('/api/account/preferences');

    return UserPreferences.fromJson(
      <String, dynamic>{
        'language': response.data!['language'] as String,
        ...response.data!['prefs'] as Map<String, dynamic>,
      },
    );
  }

  /// Read the kid mode status of the logged in user.
  ///
  /// https://lichess.org/api#tag/Account/operation/accountKid.
  @override
  Future<bool> getKidModeStatus() async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>('/api/account/kid');

    return response.data!['kid'] as bool;
  }

  /// Set the kid mode status of the logged in user.
  ///
  /// https://lichess.org/api#tag/Account/operation/accountKidPost
  @override
  @POST('/api/account/kid')
  Future<void> setMyKidModeStatus({@Query('v') required bool enableKidMode});

  /// Close the [dio] instance associated with this service instance.
  ///
  /// Note that you will not be able to use other service that uses this same [dio] instance.
  @override
  Future<void> close({bool force = false}) async => dio.close(force: force);
}
