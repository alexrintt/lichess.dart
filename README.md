## Lichess API Wrapper for Dart

Shiro is a Dart wrapper for [Lichess API](https://lichess.org/api).
This Dart package handles API calls and data classes.
This package does **not** handle authentication.

## Usage

The usage is pretty straightforward:

```dart
final shirou = ShiroClient.create();
final user = await shirou.getUserPublicData(username: 'alexrintt');

// If you wanna make authenticated requests:
final shirou = ShiroClient.create(accessToken: '<your-access-token>');
final email = await shirou.getMyEmailAddress();
```

### Custom Dio instance

By default, this package uses fresh [Dio](https://pub.dev/packages/dio) instance for handling HTTP requests, if you want to provide a custom instance, use `dio` argument:

```dart
final myDioInstance = Dio();
final shirou = ShiroClient.create(dio: myDioInstance);
```

### Custom client

`ShiroClient` is just an abstract class, you can always extend or implement it.

```dart
class MyCustomLichessClient implements ShiroClient {
  // TODO: Implement/override methods.
}
```

Now you can do your own implementation and re-use the data models.

This can also be used to mock the `ShiroClient` class.

## Retrieve access token

TL;DR: **Shiro doesn't handle authentication for Lichess**.

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

These steps are required to setup your local environment for development.

### Base environment

This package is based on Dart:

```
Dart SDK version: 2.19.2 (stable) (Tue Feb 7 18:37:17 2023 +0000) on "windows_x64"
```

### Getting started

This package uses code generation from `retrofit` and `freezed` package, so first off run:

```bash
# Get deps.
dart pub get

# Start generating code and watch for code changes.
dart pub run build_runner watch --delete-conflicting-outputs
```

Now, when there are no more errors due missing generated code, run the example:

```bash
dart bin/shirou.dart
```
