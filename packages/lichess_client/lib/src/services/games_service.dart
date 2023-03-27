import '../../lichess_client.dart';

/// {@template games}
/// Access games played on Lichess. https://lichess.org/games.
///
/// https://lichess.org/api#tag/Games
/// {@endtemplate}
abstract class GamesService with CloseableMixin {
  /// Interface for this client.
  const GamesService();

  /// Export games of a user.
  ///
  /// Download all games of any user in PGN or ndjson format.
  ///
  /// Games are sorted by reverse chronological order (most recent first).
  ///
  /// We recommend streaming the response, for it can be very long. https://lichess.org/@/german11 for instance has more than 500,000 games.
  ///
  /// The game stream is throttled, depending on who is making the request:
  /// - Anonymous request: 20 games per second.
  /// - OAuth2 authenticated request: 30 games per second.
  /// - Authenticated, downloading your own games: 60 games per second.
  ///
  /// Params:
  ///
  /// - [username] Target user.
  /// - [since] Defaults to account creation date, must be after a date after Tuesday, January 1, 2013 12:00:00.070 AM (GMT).
  /// - [until] Defaults to now, must be after a date after Tuesday, January 1, 2013 12:00:00.070 AM (GMT).
  /// - [max] How many games to download. Leave empty to download all games.
  /// - [vs], Filter by only games played against this opponent (id).
  /// - [rated], Filter by only rated (true) or casual (false) games.
  /// - [perfTypes] Default to null, filter games by speeds or variants.
  /// - [color] Filter by only games played as this color.
  /// - [analysed] Filter by only games with or without a computer analysis available.
  /// - [moves] Include the PGN moves, default to (true).
  /// - [pgnInJson] Include the full PGN within the JSON response, in a `pgn` field. The response type must be set to `application/x-ndjson` by the request `Accept` header. Default to (false).
  /// - [tags] Include the PGN tags, default to (true).
  /// - [clocks] Include clock status when available, default to (false). Either as PGN comments: `2. exd5 { [%clk 1:01:27] } e5 { [%clk 1:01:28] }`. Or in a `clocks` JSON field, as centisecond integers, depending on the response type.
  /// - [evals] Include analysis evaluations and comments, when available. Either as PGN comments: `12. Bxf6 { [%eval 0.23] } a3 { [%eval -1.09] }`. Or in an `analysis` JSON field, depending on the response type.
  /// - [accuracy] Include accuracy percent of each player, when available, default to (false).
  /// - [opening] Include the opening name. Example: `[Opening "King's Gambit Accepted, King's Knight Gambit"]`. Default to (false).
  /// - [ongoing] Include ongoing games. The last 3 moves will be omitted. Default to (false).
  /// - [finished] Include finished games. Set to false to only get ongoing games. Default to (true).
  /// - [literate] Insert textual annotations in the PGN about the opening, analysis variations, mistakes, and game termination. Example: `5... g4? { (-0.98 → 0.60) Mistake. Best move was h6. } (5... h6 6. d4 Ne7 7. g3 d5 8. exd5 fxg3 9. hxg3 c6 10. dxc6)`. Default to (false).
  /// - [lastFen] Include the FEN notation of the last position of the game. Default to (false).
  /// - [players] URL of a text file containing real names and ratings, to replace Lichess usernames and ratings in the PGN. Example: https://gist.githubusercontent.com/ornicar/6bfa91eb61a2dcae7bcd14cce1b2a4eb/raw/768b9f6cc8a8471d2555e47ba40fb0095e5fba37/gistfile1.txt.
  /// - [sort] Sort order of the games. Default to [LichessGameSort.dateDesc].
  ///
  /// https://lichess.org/api#tag/Games/operation/apiGamesUser
  Stream<LichessGame> exportGamesOfUser({
    required String username,
    DateTime? since,
    DateTime? until,
    int? max,
    String? vs,
    bool? rated,
    List<PerfType>? perfTypes,
    ChessColor? color,
    bool? analysed,
    bool moves = true,
    bool pgnInJson = false,
    bool tags = true,
    bool clocks = false,
    bool evals = true,
    bool accuracy = false,
    bool opening = false,
    bool ongoing = false,
    bool finished = true,
    bool literate = false,
    bool lastFen = false,
    String? players,
    LichessGameSort? sort,
  });

  /// Download one game in either PGN or JSON format.
  ///
  /// Ongoing games have their last 3 moves omitted, after move 5.
  ///
  /// Params:
  ///
  /// - [gameId] The game ID (8 characters).
  /// - [moves] Include the PGN moves, default to (true).
  /// - [pgnInJson] Include the full PGN within the JSON response, in a `pgn` field. The response type must be set to `application/x-ndjson` by the request `Accept` header. Default to (false).
  /// - [tags] Include the PGN tags, default to (true).
  /// - [clocks] Include clock status when available, default to (false). Either as PGN comments: `2. exd5 { [%clk 1:01:27] } e5 { [%clk 1:01:28] }`. Or in a `clocks` JSON field, as centisecond integers, depending on the response type.
  /// - [evals] Include analysis evaluations and comments, when available. Either as PGN comments: `12. Bxf6 { [%eval 0.23] } a3 { [%eval -1.09] }`. Or in an `analysis` JSON field, depending on the response type.
  /// - [accuracy] Include accuracy percent of each player, when available, default to (false).
  /// - [opening] Include the opening name. Example: `[Opening "King's Gambit Accepted, King's Knight Gambit"]`. Default to (false).
  /// - [literate] Insert textual annotations in the PGN about the opening, analysis variations, mistakes, and game termination. Example: `5... g4? { (-0.98 → 0.60) Mistake. Best move was h6. } (5... h6 6. d4 Ne7 7. g3 d5 8. exd5 fxg3 9. hxg3 c6 10. dxc6)`. Default to (false).
  /// - [players] URL of a text file containing real names and ratings, to replace Lichess usernames and ratings in the PGN. Example: https://gist.githubusercontent.com/ornicar/6bfa91eb61a2dcae7bcd14cce1b2a4eb/raw/768b9f6cc8a8471d2555e47ba40fb0095e5fba37/gistfile1.txt.
  /// - [sort] Sort order of the games. Default to [LichessGameSort.dateDesc].
  Stream<LichessGame> exportGame({
    required String gameId,
    bool moves = true,
    bool pgnInJson = false,
    bool tags = true,
    bool clocks = false,
    bool evals = true,
    bool accuracy = false,
    bool opening = false,
    bool literate = false,
    String? players,
  });
}
