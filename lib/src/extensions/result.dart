import 'package:async/async.dart';
import 'package:riverpod/riverpod.dart';

extension ResultExtension<T> on Result<T> {
  /// Returns an [AsyncValue<T>] populated with this [Result<T>] data or error.
  AsyncValue<T> get asAsyncValue => fold(
        AsyncValue.data,
        (error, stackTrace) =>
            AsyncValue.error(error, stackTrace ?? StackTrace.current),
      );

  /// Returns the value from this [ValueResult] or the result of `orElse()` if this is a [ErrorResult].
  T getOrElse(T Function() orElse) => isValue ? asValue!.value : orElse();

  /// Returns the value of this [ValueResult]
  ///
  /// Will throw the [ErrorResult] if this result is an error.
  T getOrThrow() {
    if (isValue) {
      return asValue!.value;
    }

    // ignore: only_throw_errors
    throw asError!.error;
  }

  /// Applies `onSuccess` if this is a [ValueResult] or `onError` if this is a [ErrorResult].
  U fold<U>(U Function(T value) onSuccess,
          U Function(Object error, StackTrace? stackTrace) onError) =>
      isValue
          ? onSuccess(asValue!.value)
          : onError(asError!.error, asError!.stackTrace);

  /// Execute `onSuccess` in case of [ValueResult] or `onError` in case of [ErrorResult].
  void match({
    void Function(T value)? onSuccess,
    void Function(Object error, StackTrace? stackTrace)? onError,
  }) {
    if (onSuccess != null && isValue) {
      onSuccess(asValue!.value);
    }
    if (onError != null && isError) {
      onError(asError!.error, asError!.stackTrace);
    }
  }

  /// Apply a function to a contained [ValueResult] value
  ///
  /// Equivalent to `match(onSuccess: (value) { // do sth with value })`
  void forEach(void Function(T) f) {
    if (isValue) {
      f(asValue!.value);
    }
  }

  /// Maps a [Result<T>] to [Result<U>] by applying a function
  /// to a contained [ValueResult] value, leaving an [ErrorResult] value untouched.
  ///
  /// This function can be used to compose the results of two functions.
  Result<U> map<U>(U Function(T) f) =>
      isValue ? Result.value(f(asValue!.value)) : this as Result<U>;

  /// Maps a [Result<T>] to [Result<T>] by applying a function
  /// to a contained [ErrorResult], leaving the [ValueResult] value untouched.
  ///
  /// This function can be used to pass through a successful result
  /// while applying transformation to [ErrorResult].
  Result<T> mapError<E extends Object>(
          E Function(Object error, StackTrace? stackTrace) f) =>
      isError ? Result.error(f(asError!.error, asError!.stackTrace)) : this;

  /// Maps a [Result<T>] to [Result<U>] by applying a function
  /// to a contained [ValueResult] value and unwrapping the produced result,
  /// leaving an [ErrorResult] value untouched.
  ///
  /// Use this method to avoid a nested result when your transformation
  /// produces another [Result] type.
  Result<U> flatMap<U>(Result<U> Function(T) f) =>
      isValue ? f(asValue!.value) : this as Result<U>;
}
