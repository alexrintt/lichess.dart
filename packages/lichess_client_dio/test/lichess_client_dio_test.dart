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
    as streamBoardGameState;

void main() {
  group('Board', () {
    test('https://lichess.org/api#tag/Board/operation/boardGameStream',
        () async {
      final MockDio mockDio = MockDio();

      const String kSampleGameId = '5IrD6Gzz';

      when(
        mockDio.get<ResponseBody>(
          '/api/board/game/stream/$kSampleGameId',
          options: anyNamed('options'),
          // options: create,
        ),
      ).thenAnswer(
        (_) => Future<Response<ResponseBody>>.value(
          Response<ResponseBody>(
            requestOptions: RequestOptions(),
            data: streamBoardGameState.createResponse(),
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
  });
}
