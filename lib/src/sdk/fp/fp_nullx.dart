import 'package:dartz/dartz.dart';

/// Extension for nullable types A? to treat them as Option<A> or Either<L, A>

extension NullX<A extends Object> on A? {
  Option<A> toOption() => optionOf<A>(this);
  Either<L, A> toEither<L>(L Function() onNull) => this == null ? left(onNull()) : right<L, A>(this!);
  List<A> toList() => this == null ? [] : [this!];
  Iterable<A> toIterable() => this == null ? Iterable.empty() : Iterable.generate(1, (_) => this!);
  Stream<A> toStream() => this == null ? Stream.empty() : Stream.value(this!);
}
