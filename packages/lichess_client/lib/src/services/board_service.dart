import '../../lichess_client.dart';

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
abstract class BoardService with CloseableMixin {
  /// Interface for this client.
  const BoardService();

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
  Future<LichessBoardGameIncomingEvent> streamIncomingEvents();

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
  Stream<LichessBoardGameEvent> streamBoardGameState({required String gameId});
}
