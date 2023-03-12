### If you are looking for a complete Lichess client, refer to [lichess_client_dio](https://pub.dev/lichess_client_dio) instead.

---

# Lichess API interface for Dart

[![Pub Version](https://img.shields.io/pub/v/lichess_client)](https://pub.dev/packages/lichess_client)

This is a library that defines signatures (interface) to interacting with [Lichess API](https://lichess.org/api). This also defines all required data models. It is written in pure Dart using code-generation.

**You are very unlikely to be searching for this library though, this was created to remove the HTTP library dependency from the API interface, it acts like a "platform interface" package.**

Notice: This is not an official Lichess project. It is maintained by volunteers.

## Installation

```yaml
dependencies:
  lichess_client: ^<latest-version>
```

Import:

```dart
import 'package:lichess_client/lichess_client.dart';
```

## Custom client

```dart
class MyCustomLichessClient implements LichessClient {
  // TODO: Implement/override methods.
}
```

`LichessClient` is the abstract class that defines all signatures, so you can always extend or implement it.

Now you can do your own implementation and re-use the data models.

This can also be used to mock the `LichessClient` class.

## Contributing

Dependencies other than code generation aren't allowed in this package, contributions are allowed only to change, add or remove signatures that corresponds to the [Lichess API](https://lichess.org/api), if you wanna implement something, create a new package that depends on this package instead. We also offer a [package that implements this interface using Dio as HTTP client](https://github.com/alexrintt/lichess.dart/tree/master/packages/lichess_client_dio).

### Code generation

This package uses code generation to handle data models:

```bash
# Get deps.
dart pub get

# Generate code, switch 'watch' for 'build' if you don't wanna watch for file changes.
dart run build_runner watch --delete-conflicting-outputs
```

It's done, add any model or signature and send PR.
