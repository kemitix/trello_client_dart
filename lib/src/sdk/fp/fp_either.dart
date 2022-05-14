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

/// lift1either
// Function1<Either<L, A>, Either<L, B>> lift1either<L, A, B>(B Function(A a) f) =>
//     (Either<L, A> fa) => map1either(fa, f);

/// lift2either
// Function2<Either<L, A>, Either<L, B>, Either<L, C>> lift2either<L, A, B, C>(
//         C Function(A a, B b) f) =>
//     (Either<L, A> fa, Either<L, B> fb) => map2either(fa, fb, f);

/// lift3either
// Function3<Either<L, A>, Either<L, B>, Either<L, C>, Either<L, D>>
//     lift3either<L, A, B, C, D>(D Function(A a, B b, C c) f) =>
//         (Either<L, A> fa, Either<L, B> fb, Either<L, C> fc) =>
//             map3either(fa, fb, fc, f);

/// map1either
// Either<L, B> map1either<L, A, A2 extends A, B>(
//         Either<L, A2> fa, B Function(A a) fun) =>
//     fa.fold(left, (a) => right(fun(a)));
