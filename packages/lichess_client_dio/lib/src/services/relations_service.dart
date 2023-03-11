import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lichess_client/lichess_client.dart';
import 'package:retrofit/http.dart';

import '../utils/create_dio_client_with.dart';

part 'relations_service.g.dart';

@RestApi()
abstract class RelationsServiceDio implements RelationsService {
  factory RelationsServiceDio(Dio dio) => _RelationsServiceDio._(dio, dio);

  factory RelationsServiceDio.create({
    String? accessToken,
    String baseUrl = 'https://lichess.org',
  }) =>
      RelationsServiceDio(
        createLichessDioClientWith(accessToken: accessToken, baseUrl: baseUrl),
      );

  const RelationsServiceDio._(this.dio);

  final Dio dio;

  @override
  Future<List<User>> getFollowing() async {
    final Response<String> ndjson = await dio.get<String>('/api/rel/following');

    final List<String> rawFollows = ndjson.data != null
        ? const LineSplitter().convert(ndjson.data!)
        : <String>[];

    bool allKeysAreStrings(dynamic e) =>
        e is Map && e.keys.every((dynamic key) => key is String);

    final List<User> follows = rawFollows
        .map(jsonDecode)
        .where(allKeysAreStrings)
        .cast<Map<String, dynamic>>()
        .map(User.fromJson)
        .toList();

    return follows;
  }

  @override
  @POST('/api/rel/follow/{username}')
  Future<void> followUser({@Path() required String username});

  @override
  @POST('/api/rel/unfollow/{username}')
  Future<void> unfollowUser({required String username});

  @override
  Future<void> close({bool force = false}) async => dio.close(force: force);
}
