import '../../lichess_client.dart';

/// {@template tv}
/// Access Lichess TV channels and games. https://lichess.org/tv & https://lichess.org/games.
///
/// https://lichess.org/api#tag/TV
/// {@endtemplate}
abstract class TvService with CloseableMixin {
  const TvService();

  /// Get current TV games.
  ///
  /// Get basic info about the best games being played for each speed and variant, but also computer games and bot games.
  ///
  /// See lichess.org/tv.
  ///
  /// https://lichess.org/api#tag/TV/operation/tvChannels
  Future<List<TvGameBasicInfo>> getCurrentTvGames();

  /// Stream current TV game.
  ///
  /// Stream positions and moves of the current TV game in ndjson.
  ///
  /// A summary of the game is sent as a first message, and when the featured game changes.
  ///
  /// See lichess.org/tv.
  ///
  /// https://lichess.org/api#tag/TV/operation/tvFeed
  Stream<TvGameSummary> streamCurrentTvGame();

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
  Stream<TvGameSummary> getBestOngoingGamesOfTvChannel({
    required TvChannel channel,
    int nb = 10,
    bool moves = true,
    bool pgnInJson = false,
    bool tags = true,
    bool clocks = false,
    bool opening = false,
  });

  @override
  Future<void> close({bool force = false});
}
