# Lichess for Dart

[![Pub Version](https://img.shields.io/pub/v/lichess_client_dio)](https://pub.dev/packages/lichess_client_dio) [![Pub Version](https://img.shields.io/pub/points/lichess_client_dio)](https://pub.dev/packages/lichess_client_dio)

This is a library for interacting with [Lichess API](https://lichess.org/api). It works on all platforms and exposes a collection of data classes and a extendable client interface.

Notice: This is not an official Lichess project. It is maintained by volunteers.

## Installation

```yaml
dependencies:
  lichess_client_dio: ^<latest-version>
```

Import:

```dart
import 'package:lichess_client_dio/lichess_client_dio.dart';
```

## Usage

The usage is pretty straightforward:

```dart
final lichess = LichessClientDio.create();
final user = await lichess.users.getPublicData(username: 'alexrintt');

// If you wanna make authenticated requests:
final lichess = LichessClientDio.create(accessToken: '<your-access-token>');
final email = await lichess.account.getEmailAddress();
```

Services that are currently available (complete or partially complete):

- [x] Account.
- [x] Users.
- [x] Relations.
- [x] Games.
- [x] TV.
- [x] Puzzles.
- [x] Teams.
- [x] Board.
- [ ] Bot.
- [ ] Challenges.
- [ ] Bulk pairings.
- [ ] Arena tournaments.
- [ ] Swiss tournaments.
- [ ] Simuls.
- [ ] Studies.
- [ ] Messaging.
- [ ] Broadcasts.
- [ ] Analysis.
- [ ] External engine.
- [ ] Opening Explorer.
- [ ] Tablebase.
- [ ] OAuth.

All services are accessible by `lichess.<service-name>.<endpoint-name>(...)`.

### Custom Dio instance

By default, this package uses fresh [Dio](https://pub.dev/packages/dio) instance for handling HTTP requests, if you want to provide a custom instance, use `dio` argument:

```dart
final myDioInstance = Dio();
final lichess = LichessClientDio.create(dio: myDioInstance);
```

## Retrieve access token

TL;DR: **This package doesn't handle authentication for Lichess**.

That said, to get an access token for your platform and for your use-case refer to the [Lichess authentication section](https://lichess.org/api#section/Introduction/Authentication).

## Contributing

TODO.