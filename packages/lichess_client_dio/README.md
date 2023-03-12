# Lichess for Dart

[![Pub Version](https://img.shields.io/pub/v/lichess_client_dio)](https://pub.dev/packages/lichess_client_dio) [![Pub Version](https://img.shields.io/pub/points/lichess_client_dio)](https://pub.dev/packages/lichess_client)

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
final user = await lichess.getUserPublicData(username: 'alexrintt');

// If you wanna make authenticated requests:
final lichess = LichessClientDio.create(accessToken: '<your-access-token>');
final email = await lichess.getMyEmailAddress();
```

### Custom Dio instance

By default, this package uses fresh [Dio](https://pub.dev/packages/dio) instance for handling HTTP requests, if you want to provide a custom instance, use `dio` argument:

```dart
final myDioInstance = Dio();
final lichess = LichessClientDio.create(dio: myDioInstance);
```

### Custom client

`LichessClient` is the abstract class that defines all signatures, so you can always extend or implement it.

```dart
class MyCustomLichessClient implements LichessClient {
  // TODO: Implement/override methods.
}
```

Now you can do your own implementation and re-use the data models.

This can also be used to mock the `LichessClient` class.

## Retrieve access token

TL;DR: **This package doesn't handle authentication for Lichess**.

<details>
  <summary>Why?</summary>

It may not be ideal for a package to handle user authentication due to the following reasons:

1. Security: Handling user authentication in a package can pose potential security risks. The package would require to store Lichess API tokens locally. If mishandled or not handled securely, it could result in unauthorized access to user accounts or other security issues.

2. Platform-specific concerns: If the package handles user authentication, it can have platform-specific implications. Different platforms may have different ways of handling sensitive user data, such as storing tokens in different locations or using different encryption methods. By leaving authentication up to users, the package can remain platform-independent and avoid these platform-specific concerns.

3. Flexibility: Lichess API tokens can be generated with different levels of access and permissions, and different users may require different levels of access depending on their use case. By allowing users to handle authentication themselves, the package gives them the flexibility to generate and use tokens with the necessary permissions for their specific use case.

4. Complexity: Handling user authentication can add additional complexity to the package and increase the likelihood of bugs or errors. By allowing users to handle authentication themselves, the package can focus on providing a clean and easy-to-use API for interacting with the Lichess API.

5. Best practice: Leaving authentication up to the user is generally considered best practice in API design. By following this best practice, the package can ensure that its design is in line with established industry standards.

So it is generally considered best practice to leave authentication up to the user and avoid potential security risks, platform-specific concerns, and unnecessary complexity in the package's design.

</details>

That said, to get an access token for your platform and for your use-case refer to the [Lichess authentication section](https://lichess.org/api#section/Introduction/Authentication).

## Contributing

TODO.