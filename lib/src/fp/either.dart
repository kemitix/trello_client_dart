import 'fp.dart';

abstract class Either<L, R> {
  T fold<T>({
    required Fn<L, T> onError,
    required Fn<R, T> onSuccess,
  });
  Either<L, B> map<B>(Fn<R, B> fn);
}

class Left<L, R> extends Either<L, R> {
  final L _error;
  Left.of(this._error);

  @override
  T fold<T>({
    required Fn<L, T> onError,
    required Fn<R, T> onSuccess,
  }) =>
      onError.call(_error);

  @override
  Either<L, B> map<B>(Fn<R, B> fn) => Left.of(_error);
}

class Right<L, R> extends Either<L, R> {
  final R _value;
  Right.of(this._value);

  @override
  T fold<T>({
    required Fn<L, T> onError,
    required Fn<R, T> onSuccess,
  }) =>
      onSuccess.call(_value);

  @override
  Either<L, B> map<B>(Fn<R, B> fn) => Right.of(fn.call(_value));
}
