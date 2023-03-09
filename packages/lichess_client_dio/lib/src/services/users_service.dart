import 'package:dio/dio.dart';
import 'package:lichess_client/lichess_client.dart';
import 'package:retrofit/http.dart';

import '../utils/create_dio_client_with.dart';

part 'users_service.g.dart';

@RestApi()
abstract class UsersServiceDio extends UsersService {
  factory UsersServiceDio(Dio dio) => _UsersServiceDio._(dio, dio);

  factory UsersServiceDio.create({
    String? accessToken,
    String baseUrl = 'https://lichess.org',
  }) =>
      UsersServiceDio(
        createLichessDioClientWith(accessToken: accessToken, baseUrl: baseUrl),
      );

  const UsersServiceDio._(this.dio);

  final Dio dio;

  @override
  @GET('/api/users/status')
  Future<List<RealTimeUserStatus>> getRealTimeStatus({
    @Query('ids') required List<String> ids,
    @Query('withGameIds') bool withGameIds = false,
  });

  @override
  Future<Map<String, List<User>>> getTop10() {
    // TODO: implement getTop10
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getPerfTypeLeaderboard({
    required PerfType perfType,
    int nb = 100,
  }) {
    // TODO: implement getPerfTypeLeaderboard
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getChessVariantLeaderboard({
    required PerfType variant,
    int limit = 100,
  }) {
    // TODO: implement getChessVariantLeaderboard
    throw UnimplementedError();
  }

  @override
  @GET('/api/user/{username}')
  Future<User> getPublicData({
    @Path() required String username,
    @Query('trophies') bool trophies = false,
  });

  @override
  @GET('/api/user/{username}/rating-history')
  Future<List<RatingHistory>> getRatingHistory({
    @Path('username') required String username,
  });

  @override
  Future<List<User>> getManyById({
    required List<String> ids,
  }) async {
    final String formattedIds = ids.join(',');
    final Response<List<dynamic>> response =
        await dio.post<List<dynamic>>('/api/users', data: formattedIds);

    return response.data!
        .map((dynamic e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  @GET('/api/streamer/live')
  Future<List<User>> getLiveStreamers();

  @override
  @GET('/api/player/autocomplete')
  Future<List<String>> autocompleteUsernames({
    @Query('term') required String term,
    @Query('friend') bool friend = false,
  });

  /// Custom implementation of [autocomplete] because Lichess API
  /// is returning a `Map<String, dynamic>` instead of a `List<User>` so
  /// retrofit generator can't generate the object.
  ///
  /// See https://github.com/lichess-org/api/issues/231.
  @override
  Future<List<User>> autocomplete({
    required String term,
    bool friend = false,
    bool object = true,
  }) async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>(
      '/api/player/autocomplete',
      queryParameters: <String, dynamic>{
        'term': term,
        'friend': friend,
        'object': object,
      },
    );

    final Map<String, dynamic> rawData = response.data!;

    final List<dynamic> results = rawData['result'] as List<dynamic>;

    return results
        .map((dynamic e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> close({bool force = false}) async => dio.close(force: force);
}
