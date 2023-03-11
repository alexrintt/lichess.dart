import 'package:dio/dio.dart';
import 'package:lichess_client/lichess_client.dart';
import 'package:retrofit/http.dart';

import '../utils/create_dio_client_with.dart';

part 'account_service.g.dart';

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

  final Dio dio;

  @override
  @GET('/api/account')
  Future<User> getProfile();

  @override
  Future<String> getEmailAddress() async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>('/api/account/email');

    return response.data!['email'] as String;
  }

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

  @override
  Future<bool> getKidModeStatus() async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>('/api/account/kid');

    return response.data!['kid'] as bool;
  }

  @override
  @POST('/api/account/kid')
  Future<void> setMyKidModeStatus({@Query('v') required bool enableKidMode});

  @override
  Future<void> close({bool force = false}) async => dio.close(force: force);
}
