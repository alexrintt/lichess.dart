import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../lichess_client_dio.dart';

part 'oauth_service.g.dart';

/// {@template oauth}
/// Obtaining and revoking OAuth tokens.
///
/// https://lichess.org/api#tag/OAuth
/// {@endtemplate}
@RestApi()
abstract class OAuthServiceDio implements OAuthService {
  factory OAuthServiceDio(Dio dio) => _OAuthServiceDio._(dio, dio);

  factory OAuthServiceDio.create({
    String? accessToken,
    String baseUrl = 'https://lichess.org',
  }) =>
      OAuthServiceDio(
        createLichessDioClientWith(accessToken: accessToken, baseUrl: baseUrl),
      );

  const OAuthServiceDio._(this.dio);

  /// Revokes the access token sent as Bearer for this request.
  ///
  /// https://lichess.org/api#tag/OAuth/operation/apiTokenDelete
  @override
  @DELETE('/api/token')
  Future<void> revokeAccessToken();

  /// Dio client linked with this service instance.
  final Dio dio;

  /// Close the [dio] instance associated with this service instance.
  ///
  /// Note that you will not be able to use other service that uses this same [dio] instance.
  @override
  Future<void> close({bool force = false}) async => dio.close(force: force);
}
