import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lichess_client/lichess_client.dart';
import 'package:retrofit/http.dart';

import '../utils/create_dio_client_with.dart';

part 'relations_service.g.dart';

/// {@template relations}
/// Access relations between users.
///
/// https://lichess.org/api#tag/Relations
/// {@endtemplate}
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

  /// Dio client linked with this service instance.
  final Dio dio;

  /// Get users followed by the logged in user.
  ///
  /// https://lichess.org/api#tag/Relations/operation/apiUserFollowing
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

  /// Follow a player, adding them to your list of Lichess friends.
  ///
  /// https://lichess.org/api#tag/Relations/operation/followUser
  @override
  @POST('/api/rel/follow/{username}')
  Future<void> followUser({@Path() required String username});

  /// Unfollow a player, removing them from your list of Lichess friends.
  ///
  /// https://lichess.org/api#tag/Relations/operation/unfollowUser
  @override
  @POST('/api/rel/unfollow/{username}')
  Future<void> unfollowUser({required String username});

  /// Close the [dio] instance associated with this service instance.
  ///
  /// Note that you will not be able to use other service that uses this same [dio] instance.
  @override
  Future<void> close({bool force = false}) async => dio.close(force: force);
}
