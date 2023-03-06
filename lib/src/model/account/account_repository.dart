import 'package:async/async.dart';
import 'package:logging/logging.dart';

import 'package:shiro/src/common/api_client.dart';
import 'package:shiro/src/constants.dart';
import 'package:shiro/src/extensions/future_result.dart';
import 'package:shiro/src/extensions/result.dart';
import 'package:shiro/src/model/user/user.dart';
import 'package:shiro/src/utils/json.dart';

class AccountRepository {
  const AccountRepository({
    required ApiClient apiClient,
    required Logger logger,
  })  : _apiClient = apiClient,
        _log = logger;

  final ApiClient _apiClient;
  final Logger _log;

  FutureResult<User> getProfile() {
    return _apiClient.get(Uri.parse('$kLichessHost/api/account')).then(
          (result) => result.flatMap(
            (response) => readJsonObject(
              response.body,
              mapper: User.fromJson,
              logger: _log,
            ),
          ),
        );
  }
}
