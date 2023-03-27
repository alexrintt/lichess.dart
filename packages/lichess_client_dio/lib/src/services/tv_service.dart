import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../lichess_client_dio.dart';

part 'tv_service.g.dart';

/// {@template teams}
/// Access and manage Lichess teams and their members.
///
/// https://lichess.org/api#tag/Teams
/// {@endtemplate}
@RestApi()
abstract class TvServiceDio implements TvService {
  factory TvServiceDio(Dio dio) => _TvServiceDio._(dio, dio);

  factory TvServiceDio.create({
    String? accessToken,
    String baseUrl = 'https://lichess.org',
  }) =>
      TvServiceDio(
        createLichessDioClientWith(accessToken: accessToken, baseUrl: baseUrl),
      );

  const TvServiceDio._(this.dio);

  /// Get current TV games.
  ///
  /// Get basic info about the best games being played for each speed and variant, but also computer games and bot games.
  ///
  /// See lichess.org/tv.
  ///
  /// https://lichess.org/api#tag/TV/operation/tvChannels
  @override
  Future<List<TvGameBasicInfo>> getCurrentTvGames() async {
    final Response<Map<String, dynamic>> response =
        await dio.get<Map<String, dynamic>>('/api/tv/channels');

    if (response.data == null) {
      return <TvGameBasicInfo>[];
    }

    final Map<String, dynamic> raw = response.data!;

    final List<Map<String, dynamic>> rawAsList = <Map<String, dynamic>>[
      for (final MapEntry<String, dynamic> e in raw.entries)
        <String, dynamic>{
          'channel': e.key,
          ...Map<String, dynamic>.from(e.value as Map<dynamic, dynamic>),
        },
    ];

    return rawAsList.map(TvGameBasicInfo.fromJson).toList();
  }

  /// Stream current TV game.
  ///
  /// Stream positions and moves of the current TV game in ndjson.
  ///
  /// A summary of the game is sent as a first message, and when the featured game changes.
  ///
  /// See lichess.org/tv.
  ///
  /// https://lichess.org/api#tag/TV/operation/tvFeed
  @override
  Stream<TvGameSummary> streamCurrentTvGame() async* {
    final Response<ResponseBody> response = await dio.get<ResponseBody>(
      '/api/tv/feed',
      options: Options(responseType: ResponseType.stream),
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

        if (raw is Map<dynamic, dynamic>) {
          yield TvGameSummary.fromJson(Map<String, dynamic>.from(raw));
        }
      }
    }
  }

  /// Get best ongoing games of a TV channel.
  ///
  /// Get a list of ongoing games for a given TV channel. Similar to lichess.org/games.
  ///
  /// Params:
  /// - [channel], The target channel.
  /// - [nb], Number of games to fetch, default 10, min 1 max 30.
  /// - [moves], Whether or not include the PGN moves, default true.
  /// - [pgnInJson], Whether or not include the full PGN within the JSON response, default false.
  /// - [tags], Whether or not include the PGN tags, default true.
  /// - [clocks], Whether or not include clock status when available, default false.
  /// - [opening], Whether or not include the opening name, default false.
  ///
  /// https://lichess.org/api#tag/TV/operation/tvChannelGames
  @override
  Stream<TvGameSummary> getBestOngoingGamesOfTvChannel({
    required TvChannel channel,
    int nb = 10,
    bool moves = true,
    bool pgnInJson = false,
    bool tags = true,
    bool clocks = false,
    bool opening = false,
  }) async* {
    throw NotImplemented();
  }

  /// Dio client linked with this service instance.
  final Dio dio;

  /// Close the [dio] instance associated with this service instance.
  ///
  /// Note that you will not be able to use other service that uses this same [dio] instance.
  @override
  Future<void> close({bool force = false}) async => dio.close(force: force);
}

class NotImplemented extends Error {}
