import '../../lichess_client.dart';

/// {@template account}
/// Read and write account information and preferences. https://lichess.org/account/preferences/game-display.
///
/// https://lichess.org/api#tag/Account
/// {@endtemplate}
abstract class AccountService with CloseableMixin {
  /// Interface for this client.
  const AccountService();

  /// Public information about the logged in user.
  ///
  /// https://lichess.org/api#tag/Account/operation/accountMe
  Future<User> getProfile();

  /// Read the email address of the logged in user.
  ///
  /// https://lichess.org/api#tag/Account/operation/accountEmail
  Future<String> getEmailAddress();

  /// Read the preferences of the logged in user.
  ///
  /// - https://lichess.org/account/preferences/game-display.
  /// - https://github.com/ornicar/lila/blob/master/modules/pref/src/main/Pref.scala.
  ///
  /// https://lichess.org/api#tag/Account/operation/account
  Future<UserPreferences> getMyPreferences();

  /// Read the kid mode status of the logged in user.
  ///
  /// https://lichess.org/api#tag/Account/operation/accountKid.
  Future<bool> getKidModeStatus();

  /// Set the kid mode status of the logged in user.
  ///
  /// https://lichess.org/api#tag/Account/operation/accountKidPost
  Future<void> setMyKidModeStatus({required bool enableKidMode});
}
