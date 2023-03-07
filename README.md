A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.

This package uses code generation from `retrofit` and `freezed` package, so first off run:

```shell
# Get deps.
dart pub get

# Start generating code and watch for code changes.
dart pub run build_runner watch --delete-conflicting-outputs
```

Now, when there are no more errors due missing generated code, run the example:

```shell
dart bin/shiro.dart
```
