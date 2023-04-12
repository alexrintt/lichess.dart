import 'package:dio/dio.dart' hide Headers;
import 'package:ndjson/ndjson.dart';
import 'package:retrofit/http.dart';

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
  Stream<LichessBoardGameEvent> createRealTimeSeek({
    required double increment,
    required int time,
    DaysPerTurn? days,
    bool rated = false,
    LichessVariantKey variant = LichessVariantKey.standard,
    LichessChallengeColor color = LichessChallengeColor.random,
    int? maxRating,
    int? minRating,
  }) {
    throw NotImplemented();
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
  Stream<LichessBoardGameEvent> createCorrespondenceSeek({
    required DaysPerTurn days,
    bool rated = false,
    LichessVariantKey variant = LichessVariantKey.standard,
    LichessChallengeColor color = LichessChallengeColor.random,
    double? time,
    double? increment,
    int? maxRating,
    int? minRating,
  }) {
    throw NotImplemented();
  }

  /// Close the [dio] instance associated with this service instance.
  ///
  /// Note that you will not be able to use other service that uses this same [dio] instance.
  @override
  Future<void> close({bool force = false}) async => dio.close(force: force);
}
