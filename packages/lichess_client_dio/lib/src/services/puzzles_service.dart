import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:lichess_client/lichess_client.dart';
import 'package:retrofit/http.dart';

import '../utils/create_dio_client_with.dart';

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
  Future<Puzzle> getDailyPuzzle();

  /// Get a puzzle by its ID.
  ///
  /// https://lichess.org/api#tag/Puzzles/operation/apiPuzzleId
  @override
  @GET('/api/puzzle/{id}')
  Future<Puzzle> getPuzzleById({
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
  Stream<PuzzleActivity> getPuzzleActivity({int? max}) async* {
    final Response<ResponseBody> response = await dio.get<ResponseBody>(
      '/api/puzzle/activity',
      options: Options(responseType: ResponseType.stream),
      queryParameters: max == null
          ? null
          : <String, dynamic>{
              'max': max,
            },
    );

    final StringBuffer buffered = StringBuffer();

    await for (final Uint8List part
        in response.data?.stream ?? const Stream<Uint8List>.empty()) {
      final String chunk = utf8.decode(part);

      buffered.write(chunk);

      late int i;

      while ((i = buffered.toString().indexOf('\n')) != -1) {
        final String obj = buffered.toString().substring(0, i);
        final String rest = buffered.toString().substring(i + 1);

        buffered.clear();
        buffered.write(rest);

        if (obj.isEmpty) {
          continue;
        }

        final dynamic raw = jsonDecode(obj);

        if (raw is Map<String, dynamic>) {
          yield PuzzleActivity.fromJson(Map<String, dynamic>.from(raw));
        }
      }
    }
  }

  /// Get your puzzle dashboard.
  ///
  /// https://lichess.org/api#tag/Puzzles/operation/apiPuzzleDashboard
  @override
  @GET('/api/puzzle/dashboard/{days}')
  Future<PuzzleDashboard> getPuzzleDashboard({
    @Path('days') int? days = 30,
  });
}
