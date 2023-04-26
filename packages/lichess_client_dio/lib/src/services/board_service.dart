import 'dart:async';

import 'package:dio/dio.dart';
import 'package:ndjson/ndjson.dart';
import 'package:retrofit/http.dart' hide Headers;

import '../../lichess_client_dio.dart';

part 'board_service.g.dart';

/// {@template board}
/// Play on Lichess with physical boards and third-party clients. Works with normal Lichess accounts. Engine play or assistance is [forbidden](https://lichess.org/page/fair-play).
///
/// ### Features
///
/// - [Stream incoming chess moves](https://lichess.org/api#operation/boardGameStream).
/// - [Play chess moves](https://lichess.org/api#operation/boardGameMove).
/// - [Read](https://lichess.org/api#operation/boardGameStream) and [write](https://lichess.org/api#operation/boardGameChatPost) in the player and spectator chats.
/// - [Receive](https://lichess.org/api#operation/apiStreamEvent), [create](https://lichess.org/api#operation/challengeCreate) and [accept](https://lichess.org/api#operation/challengeAccept) (or [decline](https://lichess.org/api#operation/challengeDecline)) challenges.
/// - [Abort](https://lichess.org/api#operation/boardGameAbort) and [resign](https://lichess.org/api#operation/boardGameResign) games.
/// - Compatible with normal Lichess accounts.
///
/// https://lichess.org/api#tag/Board
/// {@endtemplate}
@RestApi()
abstract class BoardServiceDio implements BoardService {
  factory BoardServiceDio(Dio dio) => _BoardServiceDio._(dio, dio);

  factory BoardServiceDio.create({
    String? accessToken,
    String baseUrl = 'https://lichess.org',
  }) =>
      BoardServiceDio(
        createLichessDioClientWith(accessToken: accessToken, baseUrl: baseUrl),
      );

  const BoardServiceDio._(this.dio);

  /// Dio client linked with this service instance.
  final Dio dio;

  /// Stream the events reaching a lichess user in real time as [ndjson](https://lichess.org/api#section/Introduction/Streaming-with-ND-JSON).
  ///
  /// An empty line is sent every 6 seconds for keep alive purposes.
  ///
  /// Each non-empty line is a JSON object containing a type field. Possible values are:
  ///
  /// - `gameStart` Start of a game.
  /// - `gameFinish` Completion of a game.
  /// - `challenge` A player sends you a challenge or you challenge someone.
  /// - `challengeCanceled` A player cancels their challenge to you.
  /// - `challengeDeclined` The opponent declines your challenge.
  ///
  /// When the stream opens, all current challenges and games are sent.
  ///
  /// https://lichess.org/api#tag/Board/operation/apiStreamEvent
  @override
  Stream<LichessBoardGameIncomingEvent> streamIncomingEvents() async* {
    final Response<ResponseBody> response = await dio.get(
      '/api/stream/event',
      options: createNdjsonDioOptions(),
    );

    await for (final NdjsonLine ndjsonLine
        in response.data?.stream.parseNdjson() ??
            const Stream<NdjsonLine>.empty()) {
      if (!ndjsonLine.isMap) {
        // Not json obj, ignore.
        continue;
      }

      final Map<String, dynamic> rawData = ndjsonLine.asMap();

      switch (rawData['type']) {
        case 'challenge':
          yield LichessChallengeEvent.fromJson(rawData);
          break;
        case 'challengeCanceled':
          yield LichessChallengeCanceledEvent.fromJson(rawData);
          break;
        case 'challengeDeclined':
          yield LichessChallengeDeclinedEvent.fromJson(rawData);
          break;
        case 'gameStart':
          yield LichessGameStartEvent.fromJson(rawData);
          break;
        case 'gameFinish':
          yield LichessGameFinishEvent.fromJson(rawData);
          break;
      }
    }
  }

  /// Stream the state of a game being played with the Board API, as [ndjson](https://lichess.org/api#section/Introduction/Streaming-with-ND-JSON).
  ///
  /// Use this endpoint to get updates about the game in real-time, with a single request.
  ///
  /// Each line is a JSON object containing a type `field`. Possible values are:
  ///
  /// - `gamefull` Full game data. All values are immutable, except for the state field.
  /// - `gameState` Current state of the game. Immutable values not included. Sent when a move is played, a draw is offered, or when the game ends.
  /// - `chatLine` Chat message sent by a user in the `room` "player" or "spectator".
  /// - `opponentGone` Whether the opponent has left the game, and how long before you can claim a win or draw.
  /// - The first line is always of type `gameFull`.
  ///
  /// The server closes the stream when the game ends, or if the game has already ended.
  ///
  /// https://lichess.org/api#tag/Board/operation/boardGameStream
  @override
  Stream<LichessBoardGameEvent> streamBoardGameState({
    required String gameId,
  }) async* {
    final Response<ResponseBody> response = await dio.get(
      '/api/board/game/stream/$gameId',
      options: createNdjsonDioOptions(),
    );

    await for (final NdjsonLine ndjsonLine
        in response.data?.stream.parseNdjson() ??
            const Stream<NdjsonLine>.empty()) {
      if (!ndjsonLine.isMap) {
        // Not json obj, ignore.
        continue;
      }

      final Map<String, dynamic> rawData = ndjsonLine.asMap();

      switch (rawData['type']) {
        case 'gameFull':
          yield LichessGameFullEvent.fromJson(rawData);
          break;
        case 'gameState':
          yield LichessGameStateEvent.fromJson(rawData);
          break;
        case 'chatLine':
          yield LichessChatLineEvent.fromJson(rawData);
          break;
        case 'opponentGone':
          yield LichessOpponentGoneEvent.fromJson(rawData);
          break;
      }
    }
  }

  /// {@template createseek}
  /// ## Create a seek
  ///
  /// Create a public seek, to start a game with a random player.
  ///
  /// ### Real-time seek
  ///
  /// Specify the `time` and `increment` clock values. The response is streamed but doesn't contain any information.
  ///
  /// **Keep the connection open to keep the seek active.**
  ///
  /// If the client closes the connection, the seek is canceled. This way, if the client terminates, the user won't be paired in a game they wouldn't play. When the seek is accepted, or expires, the server closes the connection.
  ///
  /// **Make sure to also have an [Event stream](1) open**, to be notified when a game starts. We recommend opening the Event stream first, then the seek stream. This way, you won't miss the game event if the seek is accepted immediately.
  ///
  /// https://lichess.org/api#tag/Board/operation/apiBoardSeek
  ///
  /// ### Correspondence seek
  ///
  /// Specify the `days` per turn value. The response is not streamed, it immediately completes with the seek ID. The seek remains active on the server until it is joined by someone.
  ///
  /// {@endtemplate}
  ///
  /// **Parameters of the seek:**
  ///
  /// - [rated] Whether the game is rated and impacts players ratings (Default: false).
  /// - [time] Clock initial time in minutes. Required for real-time seeks (Number between 0 and 180).
  /// - [increment] Clock increment in seconds. Required for real-time seeks (Integer between 0 and 180).
  /// - [days] Days per turn. Required for correspondence seeks (Enum: 1, 2, 3, 5, 7, 10, 14).
  /// - [variant] Variant key of this game (Enum: [LichessVariantKey]).
  /// - [color] The color to play. Better left empty to automatically get 50% white.
  /// - [ratingRange] The rating range of potential opponents. Better left empty. Example: 1500-1800.
  ///
  /// [1]: https://lichess.org/api#operation/apiStreamEvent
  Future<Future<void> Function()> createRealTimeSeek({
    required int increment,
    required double time,
    DaysPerTurn? days,
    bool rated = false,
    LichessVariantKey variant = LichessVariantKey.standard,
    LichessChallengeColor color = LichessChallengeColor.random,
    int? maxRating,
    int? minRating,
  }) async {
    return _createSeekRequestWithCancelableCallback(
      color: color,
      days: days,
      increment: increment,
      maxRating: maxRating,
      minRating: minRating,
      rated: rated,
      time: time,
      variant: variant,
    );
  }

  /// {@macro createseek}
  ///
  /// **Parameters of the seek:**
  ///
  /// - [rated] Whether the game is rated and impacts players ratings (Default: false).
  /// - [time] Clock initial time in minutes (Number between 0 and 180).
  /// - [increment] Clock increment in seconds (Integer between 0 and 180).
  /// - [days] Days per turn (Enum: 1, 2, 3, 5, 7, 10, 14).
  /// - [variant] Variant key of this game (Enum: [LichessVariantKey]).
  /// - [color] The color to play. Better left empty to automatically get 50% white.
  /// - [ratingRange] The rating range of potential opponents. Better left empty. Example: 1500-1800.
  ///
  /// [1]: https://lichess.org/api#operation/apiStreamEvent
  Future<Future<void> Function()> createCorrespondenceSeek({
    required DaysPerTurn days,
    bool rated = false,
    LichessVariantKey variant = LichessVariantKey.standard,
    LichessChallengeColor color = LichessChallengeColor.random,
    double? time,
    int? increment,
    int? maxRating,
    int? minRating,
  }) {
    return _createSeekRequestWithCancelableCallback(
      color: color,
      days: days,
      increment: increment,
      maxRating: maxRating,
      minRating: minRating,
      rated: rated,
      time: time,
      variant: variant,
    );
  }

  /// Make a move in a game being played with the Board API.
  ///
  /// The move can also contain a draw offer/agreement.
  ///
  /// Params:
  ///
  /// - [gameId] Target game ID. Example: `5IrD6Gzz`.
  /// - [move] The move to play, in UCI format. Example: `e2e4`.
  ///
  /// https://lichess.org/api#tag/Board/operation/boardGameMove
  @override
  @POST('/api/board/game/{gameId}/move/{move}')
  Future<void> makeBoardMove({
    @Path() required String gameId,
    @Path() required String move,
    @Query('offeringDraw') bool? offeringDraw,
  });

  /// Resign a game being played with the Board API.
  ///
  /// Params:
  ///
  /// - [gameId] Target game ID. Example: `5IrD6Gzz`.
  ///
  /// https://lichess.org/api#tag/Board/operation/boardGameResign
  @override
  @POST('/api/board/game/{gameId}/resign')
  Future<void> resignGame(@Path() String gameId);

  /// Abort a game being played with the Board API.
  ///
  /// Params:
  ///
  /// - [gameId] Target game ID. Example: `5IrD6Gzz`.
  ///
  /// https://lichess.org/api#tag/Board/operation/boardGameAbort
  @override
  @POST('/api/board/game/{gameId}/abort')
  Future<void> abortGame(@Path() String gameId);

  /// Post a message to the player or spectator chat, in a game being played with the Board API.
  ///
  /// Params:
  ///
  /// - [gameId] Target game ID. Example: `5IrD6Gzz`.
  /// - [room] Target game room. Enum: "player" "spectator".
  /// - [text] Chat message text.
  ///
  /// https://lichess.org/api#tag/Board/operation/boardGameChatPost
  @override
  Future<void> writeInTheChat({
    required String gameId,
    required LichessChatLineRoom room,
    required String text,
  }) async {
    final Map<String, String> body = <String, String>{
      'room': room.raw,
      'text': text,
    };

    await dio.post<void>(
      '/api/board/game/$gameId/abort',
      data: body,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
  }

  /// Get the messages posted in the game chat.
  ///
  /// Params:
  ///
  /// - [gameId] Target game ID. Example: `5IrD6Gzz`.
  ///
  /// https://lichess.org/api#tag/Board/operation/boardGameChatGet
  @override
  Stream<LichessGameChatMessage> fetchGameChat(String gameId) async* {
    final Response<ResponseBody> response = await dio.get(
      '/api/board/game/$gameId/chat',
      options: createNdjsonDioOptions(),
    );

    await for (final NdjsonLine ndjsonLine
        in response.data?.stream.parseNdjson() ??
            const Stream<NdjsonLine>.empty()) {
      if (!ndjsonLine.isMap) {
        // Not json obj, ignore.
        continue;
      }

      yield LichessGameChatMessage.fromJson(ndjsonLine.asMap());
    }
  }

  /// Claim victory when the opponent has left the game for a while.
  ///
  /// Params:
  ///
  /// - [gameId] Target game ID. Example: `5IrD6Gzz`.
  ///
  /// https://lichess.org/api#tag/Board/operation/boardGameClaimVictory
  @override
  @POST('/api/board/game/{gameId}/claim-victory')
  Future<void> claimVictory(@Path() String gameId);

  Future<Dio> _createSeekRequestWithFreshClient({
    bool rated = false,
    double? time,
    int? increment,
    DaysPerTurn? days,
    LichessVariantKey variant = LichessVariantKey.standard,
    LichessChallengeColor color = LichessChallengeColor.random,
    int? maxRating,
    int? minRating,
  }) async {
    assert(
      (() {
        if (time != null) {
          return time >= 0 && time <= 180;
        }
        return true;
      })(),
      'Range for [time] is between [0] and [180].',
    );
    assert(
      (() {
        if (increment != null) {
          return increment >= 0 && increment <= 180;
        }
        return true;
      })(),
      'Range for [increment] is between [0] and [180].',
    );
    assert(
      (maxRating != null && minRating != null) ||
          (maxRating == null && minRating == null),
      '''You must either provide both ([maxRating] AND [minRating]) OR set both to null (recommended).''',
    );
    assert(
      (() {
        if (maxRating != null && minRating != null) {
          return maxRating >= minRating && minRating >= 0;
        }
        return true;
      })(),
      '''[maxRating] must be greather or equal to [minRating]. [minRating] also MUST BE greather or equal to [0].''',
    );

    final Dio requestDioClient = Dio(dio.options);

    final Map<String, String> body = <String, String>{
      'rated': rated.toString(),
      if (time != null) 'time': time.toString(),
      if (increment != null) 'increment': increment.toString(),
      if (days?.raw != null) 'days': days!.raw.toString(),
      'variant': variant.raw,
      'color': color.raw,
      'ratingRange': '$minRating-$maxRating',
    };

    await requestDioClient.get<void>(
      '/api/board/seek',
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
      data: body,
    );

    // Returns a callback that closes the connection which cancels the seek request.
    return requestDioClient;
  }

  Future<Future<void> Function()> _createSeekRequestWithCancelableCallback({
    bool rated = false,
    double? time,
    int? increment,
    DaysPerTurn? days,
    LichessVariantKey variant = LichessVariantKey.standard,
    LichessChallengeColor color = LichessChallengeColor.random,
    int? maxRating,
    int? minRating,
  }) async {
    final Dio requestDioClient = await _createSeekRequestWithFreshClient(
      color: color,
      days: days,
      increment: increment,
      maxRating: maxRating,
      minRating: minRating,
      rated: rated,
      time: time,
      variant: variant,
    );

    // Returns a callback that closes the connection which cancels the seek request.
    return () async => requestDioClient.close(force: true);
  }

  /// Close the [dio] instance associated with this service instance.
  ///
  /// Note that you will not be able to use other service that uses this same [dio] instance.
  @override
  Future<void> close({bool force = false}) async => dio.close(force: force);
}
