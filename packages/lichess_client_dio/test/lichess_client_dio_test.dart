import 'package:dio/dio.dart';
import 'package:lichess_client_dio/lichess_client_dio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

@GenerateNiceMocks(
  <MockSpec<Object>>[
    MockSpec<Dio>(),
  ],
)
import 'lichess_client_dio_test.mocks.dart';
import 'responses/streamBoardGameState/create_response.dart'
    as stream_board_game_state;
import 'responses/streamIncomingEvents/create_response.dart'
    as stream_incoming_events;

void main() {
  group('Board', () {
    test('https://lichess.org/api#tag/Board/operation/boardGameStream',
        () async {
      final MockDio mockDio = MockDio();

      const String kSampleGameId = '5IrD6Gzz';

      when(
        mockDio.get<ResponseBody>(
          '/api/board/game/stream/$kSampleGameId',
          options: argThat(isValidNdjsonOptions, named: 'options'),
        ),
      ).thenAnswer(
        (_) => Future<Response<ResponseBody>>.value(
          Response<ResponseBody>(
            requestOptions: RequestOptions(),
            data: stream_board_game_state.createResponse(),
          ),
        ),
      );

      final LichessClient lichessClient = LichessClientDio(mockDio);

      final List<LichessBoardGameEvent> boardGameEvents = await lichessClient
          .board
          .streamBoardGameState(gameId: kSampleGameId)
          .toList();

      // Verify if all events were successfully loaded and converted.
      expect(
        boardGameEvents.map((LichessBoardGameEvent e) => e.type).toSet().length,
        equals(LichessBoardGameEventType.values.length),
      );

      // Verify if the game full event was provided as the first event.
      expect(boardGameEvents.first.type, LichessBoardGameEventType.gameFull);

      // Verify if the returned game ID is the same as the requested one.
      expect(
        (boardGameEvents.first as LichessGameFullEvent).id,
        equals(kSampleGameId),
      );
    });
    test('https://lichess.org/api#tag/Board/operation/apiStreamEvent',
        () async {
      final MockDio mockDio = MockDio();

      when(
        mockDio.get<ResponseBody>(
          '/api/stream/event',
          options: argThat(isValidNdjsonOptions, named: 'options'),
        ),
      ).thenAnswer(
        (_) => Future<Response<ResponseBody>>.value(
          Response<ResponseBody>(
            requestOptions: RequestOptions(),
            data: stream_incoming_events.createResponse(),
          ),
        ),
      );

      final LichessClient lichessClient = LichessClientDio(mockDio);

      final List<LichessBoardGameIncomingEvent> incomingBoardEvents =
          await lichessClient.board.streamIncomingEvents().toList();

      // Verify if all events were successfully loaded and converted.
      expect(
        incomingBoardEvents
            .map((LichessBoardGameIncomingEvent e) => e.type)
            .toSet()
            .length,
        equals(LichessBoardGameIncomingEventType.values.length),
      );

      // Verify if the game full event was provided as the first event.
      expect(
        incomingBoardEvents.first.type,
        LichessBoardGameIncomingEventType.challenge,
      );
    });
  });
}

const _IsValidNdjsonOptions isValidNdjsonOptions = _IsValidNdjsonOptions();

class _IsValidNdjsonOptions extends Matcher {
  const _IsValidNdjsonOptions();

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    final Options ndjsonOptions = createNdjsonDioOptions();

    return item is Options &&
        item.responseType == ndjsonOptions.responseType &&
        equals(ndjsonOptions.headers).matches(item.headers, matchState) &&
        item.contentType == ndjsonOptions.contentType;
  }

  @override
  Description describe(Description description) => description
      .add('given options does not match options of [createNdjsonDioOptions]');
}
