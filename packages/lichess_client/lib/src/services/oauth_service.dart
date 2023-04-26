import '../../lichess_client.dart';

/// {@template oauth}
/// Obtaining and revoking OAuth tokens.
///
/// https://lichess.org/api#tag/OAuth
/// {@endtemplate}
abstract class OAuthService with CloseableMixin {
  /// Interface for this client.
  const OAuthService();

  /// Revokes the access token sent as Bearer for this request.
  ///
  /// https://lichess.org/api#tag/OAuth/operation/apiTokenDelete
  Future<void> revokeAccessToken();
}
