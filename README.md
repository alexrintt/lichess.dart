A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.

---

## Base environment

This package is based on Dart:

```
Dart SDK version: 2.19.2 (stable) (Tue Feb 7 18:37:17 2023 +0000) on "windows_x64"
```

## Getting started

This package uses code generation from `retrofit` and `freezed` package, so first off run:

```bash
# Get deps.
dart pub get

# Start generating code and watch for code changes.
dart pub run build_runner watch --delete-conflicting-outputs
```

Now, when there are no more errors due missing generated code, run the example:

```bash
dart bin/shiro.dart
```
