import 'fp.dart';

/// map1eitherFM - map 1 `Either` onto a plain function that returns an `Either`
Either<L, R> map1eitherFM<L, A, A2 extends A, R>(
  Either<L, A2> fa,
  Either<L, R> Function(A a) fn,
) =>
    fa.fold(left, (a) => fn(a));

/// map1either - map 1 `Either` onto a plain function
Either<L, R> map1either<L, A, A2 extends A, R>(
  Either<L, A2> fa,
  R Function(A a) fn,
) =>
    fa.fold(
        left,
        (a) => right(fn(
              a,
            )));

/// map1either1 - map 1 `Either` and 1 plain onto a plain function
Either<L, R> map1either1<L, A, A2 extends A, B, R>(
  Either<L, A2> fa,
  B b,
  R Function(A a, B b) fn,
) =>
    fa.fold(left, (a) => right(fn(a, b)));

/// map1either2 - map 1 `Either` and 2 plain onto a plain function
Either<L, R> map1either2<L, A, A2 extends A, B, C, R>(
  Either<L, A2> fa,
  B b,
  C c,
  R Function(A a, B b, C c) fn,
) =>
    fa.fold(left, (a) => right(fn(a, b, c)));

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

/// defer1either1
Future<Either<L, R>> defer1either1<A, B, L, R>(
  Either<L, A> a,
  B b,
  Future<Either<L, R>> Function(A, B) fn,
) async =>
    (await map1either1(a, b, (A a, B b) => fn(a, b)).traverseFuture(id))
        .flatMap(id);

/// defer1either2
Future<Either<L, R>> defer1either2<A, B, C, L, R>(
  Either<L, A> a,
  B b,
  C c,
  Future<Either<L, R>> Function(A, B, C) fn,
) async =>
    (await map1either2(a, b, c, (A a, B b, C c) => fn(a, b, c))
            .traverseFuture(id))
        .flatMap(id);

/// defer2either
Future<Either<L, R>> defer2either<A, B, C, L, R>(
  Either<L, A> a,
  Either<L, B> b,
  Future<Either<L, R>> Function(A, B) fn,
) async =>
    (await map2either(a, b, (A a, B b) => fn(a, b)).traverseFuture(id))
        .flatMap(id);

/// defer3either
Future<Either<L, R>> defer3either<A, B, C, L, R>(
  Either<L, A> a,
  Either<L, B> b,
  Either<L, C> c,
  Future<Either<L, R>> Function(A, B, C) fn,
) async =>
    (await map3either(a, b, c, (A a, B b, C c) => fn(a, b, c))
            .traverseFuture(id))
        .flatMap(id);

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
