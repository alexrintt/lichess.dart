import 'dart:async';
import 'package:async/async.dart';

import './result.dart';

/// `FutureResult<T>` represents an asynchronous computation.
typedef FutureResult<T> = Future<Result<T>>;

extension FutureResultExtension<T> on FutureResult<T> {
  /// Executes `computation` and returns a FutureResult while catching any error.
  static FutureResult<T> guard<T>(Future<T> Function() computation) async {
    try {
      return Result.value(await computation());
    } catch (err, stack) {
      return Result.error(err, stack);
    }
  }

  /// Applies `onSuccess` if this is a [ValueResult] or `onError` if this is a [ErrorResult].
  Future<U> fold<U>(FutureOr<U> Function(T value) onSuccess,
          FutureOr<U> Function(Object error, StackTrace? stackTrace) onError) =>
      then((result) => result.fold(onSuccess, onError));

  /// Maps an [FutureResult<T>] to [FutureResult<U>] by applying a function
  /// to a contained [ValueResult] value, leaving an [ErrorResult] value untouched.
  ///
  /// This function can be used to compose the results of two functions.
  FutureResult<U> map<U>(U Function(T) f) => then((result) => result.map(f));

  /// Maps an [FutureResult<T>] to an [FutureResult<T>] by applying a function
  /// to a contained [ErrorResult], leaving the [ValueResult] value untouched.
  ///
  /// This function can be used to pass through a successful result
  /// while applying transformation to [ErrorResult].
  FutureResult<T> mapError<E extends Object>(
          E Function(Object error, StackTrace? stackTrace) f) =>
      then((result) => result.mapError(f));

  /// Execute `onSuccess` in case of [ValueResult] or `onError` in case of [ErrorResult].
  Future<void> match({
    void Function(T value)? onSuccess,
    void Function(Object error, StackTrace? stackTrace)? onError,
  }) =>
      then((result) => result.match(onSuccess: onSuccess, onError: onError));

  /// Apply a function to a contained [ValueResult] value
  ///
  /// Equivalent to `match(onSuccess: (value) { // do sth with value })`
  Future<void> forEach(void Function(T) f) =>
      then((result) => result.forEach(f));

  /// Maps an [FutureResult<T>] to [FutureResult<U>] by applying a function
  /// to a contained [ValueResult] value and unwrapping the produced result,
  /// leaving an [ErrorResult] value untouched.
  ///
  /// Use this method to avoid a nested result when your transformation
  /// produces another [Result] type.
  FutureResult<U> flatMap<U>(FutureOr<Result<U>> Function(T) f) =>
      then((result) => result.fold(f, ErrorResult.new));
}
