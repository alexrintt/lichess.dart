const kLichessHost =
    String.fromEnvironment('LICHESS_HOST', defaultValue: 'https://lichess.dev');
const kLichessDevUser =
    String.fromEnvironment('LICHESS_DEV_USER', defaultValue: 'lichess');
const kLichessDevPassword = String.fromEnvironment('LICHESS_DEV_PASSWORD');

const kLichessClientId = 'lichess_mobile';

abstract class RequestCacheDuration {
  /// Default cache duration for requests
  static const standard = Duration(minutes: 1);

  /// Cache duration for data that need to refreshed more often
  static const short = Duration(seconds: 10);
}

// lichess
// https://github.com/lichess-org/lila/blob/4562a83cdb263c3ebf7e148c0f666f0ff92b91c7/modules/rating/src/main/Glicko.scala#L71
const kProvisionalDeviation = 110;
const kClueLessDeviation = 230;
