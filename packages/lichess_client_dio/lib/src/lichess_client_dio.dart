import 'package:dio/dio.dart';

import '../lichess_client_dio.dart';

class LichessClientDio extends LichessClient {
  LichessClientDio(this.dio);

  factory LichessClientDio.create({
    String? accessToken,
    String baseUrl = 'https://lichess.org',
  }) =>
      LichessClientDio(
        createLichessDioClientWith(accessToken: accessToken, baseUrl: baseUrl),
      );

  final Dio dio;

  AccountServiceDio? _account;
  RelationsServiceDio? _relations;
  UsersServiceDio? _users;
  TeamsServiceDio? _teamsService;

  /// {@macro account}
  @override
  AccountServiceDio get account => _account ??= AccountServiceDio(dio);

  /// {@macro relations}
  @override
  RelationsServiceDio get relations => _relations ??= RelationsServiceDio(dio);

  /// {@macro users}
  @override
  UsersServiceDio get users => _users ?? UsersServiceDio(dio);

  /// {@macro teams}
  @override
  TeamsServiceDio get teams => _teamsService ??= TeamsServiceDio(dio);

  /// Call [close] on the [dio] instance associated with this client.
  @override
  Future<void> close({bool force = false}) async => dio.close(force: force);
}
