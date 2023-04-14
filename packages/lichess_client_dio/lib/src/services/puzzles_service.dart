import 'package:dio/dio.dart';
import 'package:ndjson/ndjson.dart';
import 'package:retrofit/http.dart';

import '../../lichess_client_dio.dart';

part 'puzzles_service.g.dart';

/// {@template puzzles}
/// Read information about puzzles.
///
/// https://lichess.org/api#tag/Puzzles
/// {@endtemplate}
@RestApi()
abstract class PuzzlesServiceDio implements PuzzlesService {
  factory PuzzlesServiceDio(Dio dio) => _PuzzlesServiceDio._(dio, dio);

  factory PuzzlesServiceDio.create({
    String? accessToken,
    String baseUrl = 'https://lichess.org',
  }) =>
      PuzzlesServiceDio(
        createLichessDioClientWith(accessToken: accessToken, baseUrl: baseUrl),
      );

  const PuzzlesServiceDio._({required this.dio});

  /// Dio client linked with this service instance.
  final Dio dio;

  /// Get the Daily Puzzle.
  ///
  /// https://lichess.org/api#tag/Puzzles/operation/apiPuzzleDaily
  @override
  @GET('/api/puzzle/daily')
  Future<LichessPuzzle> getDailyPuzzle();

  /// Get a puzzle by its ID.
  ///
  /// https://lichess.org/api#tag/Puzzles/operation/apiPuzzleId
  @override
  @GET('/api/puzzle/{id}')
  Future<LichessPuzzle> getPuzzleById({
    @Path('id') required String id,
  });

  /// Download your puzzle activity.
  ///
  /// Puzzle activity is sorted by reverse chronological order (most recent first).
  /// [max] is the maximum number of puzzle activities to return.
  /// If not specified, all puzzle activities will be returned.
  ///
  /// https://lichess.org/api#tag/Puzzles/operation/apiPuzzleActivity
  @override
  Stream<LichessPuzzleActivity> getPuzzleActivity({int? max}) async* {
    final Response<ResponseBody> response = await dio.get<ResponseBody>(
      '/api/puzzle/activity',
      options: createNdjsonDioOptions(),
      queryParameters: max == null
          ? null
          : <String, dynamic>{
              'max': max,
            },
    );

    if (response.data != null) {
      yield* response.data!.stream
          .parseNdjsonWithConverter<LichessPuzzleActivity>(
        whenMap: LichessPuzzleActivity.fromJson,
      );
    }
  }

  /// Get your puzzle dashboard.
  ///
  /// https://lichess.org/api#tag/Puzzles/operation/apiPuzzleDashboard
  @override
  @GET('/api/puzzle/dashboard/{days}')
  Future<LichessPuzzleDashboard> getPuzzleDashboard({
    @Path('days') int? days = 30,
  });
}
