import 'package:dartz/dartz.dart';

extension CollapsableEither<L, R> on Either<L, R> {
  T collapse<T>(T Function(Either<L, R>) fn) => fn(this);
}

extension UnrwappableFutureInEither<L, R> on Either<L, Future<Either<L, R>>> {
  Future<Either<L, R>> unwrapFuture() async =>
      (await Either.sequenceFuture(this)).flatMap(id);
}
