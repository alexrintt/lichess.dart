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

  AccountService? _account;
  RelationsService? _relations;
  UsersService? _users;
  TeamsService? _teamsService;

  @override
  AccountService get account => _account ??= AccountServiceDio(dio);

  @override
  RelationsService get relations => _relations ??= RelationsServiceDio(dio);

  @override
  UsersService get users => _users ?? UsersServiceDio(dio);

  @override
  TeamsService get teams => _teamsService ??= TeamsServiceDio(dio);

  /// Call [close] on the [dio] instance associated with this client.
  @override
  Future<void> close({bool force = false}) async => dio.close(force: force);
}
