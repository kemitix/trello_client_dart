import 'fp.dart';

/// map2either - map 2 `Either`s onto a plain function
Either<L, R> map2either<L, A, A2 extends A, B, B2 extends B, R>(
  Either<L, A2> fa,
  Either<L, B2> fb,
  R Function(A a, B b) fn,
) =>
    fa.fold(
        left,
        (a) => fb.fold(
            left,
            (b) => right(fn(
                  a,
                  b,
                ))));

/// map3either - map 3 `Either`s onto a plain function
Either<L, R>
    map3either<L, A, A2 extends A, B, B2 extends B, C, C2 extends C, R>(
  Either<L, A2> fa,
  Either<L, B2> fb,
  Either<L, C2> fc,
  R Function(A a, B b, C c) fn,
) =>
        fa.fold(
            left,
            (a) =>
                fb.fold(left, (b) => fc.fold(left, (c) => right(fn(a, b, c)))));
