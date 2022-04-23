import 'package:dartz/dartz.dart';

extension CollapsibleEither<L, R> on Either<L, R> {
  T collapse<T>(T Function(Either<L, R>) fn) => fn(this);
}
