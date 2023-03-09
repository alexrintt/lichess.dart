import 'dart:io';

import 'package:lichess_client/lichess_client.dart';

class MyCustomAccountService implements AccountService {
  /// A cool custom service implementation...

  @override
  void noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MyCustomRelationsService implements RelationsService {
  /// A cool custom service implementation...

  @override
  void noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MyCustomUsersService implements UsersService {
  /// A cool custom service implementation...

  @override
  void noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MyCustomLichessClient extends LichessClient {
  @override
  AccountService get account => MyCustomAccountService();

  @override
  Future<void> close({bool force = false}) async {
    stdout.write('Because you can not download RAM.');
  }

  @override
  RelationsService get relations => MyCustomRelationsService();

  @override
  UsersService get users => MyCustomUsersService();
}

void main() => _tryRunAndThrowGhostImplementation();

Future<void> _tryRunAndThrowGhostImplementation() async {
  final MyCustomLichessClient customClient = MyCustomLichessClient();
  await customClient.account.getEmailAddress();
}
