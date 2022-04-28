import 'package:fpdart/fpdart.dart';

extension CollapsableEither<L, R> on Either<L, R> {
  T collapse<T>(T Function(Either<L, R>) fn) => fn(this);
}
