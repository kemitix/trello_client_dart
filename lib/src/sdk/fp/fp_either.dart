import 'fp.dart';

// // lift
// Function1<Either<L, A>, Either<L, B>> lift1either<L, A, B>(B Function(A a) f) =>
//     (Either<L, A> fa) => map1either(fa, f);

Function2<Either<L, A>, Either<L, B>, Either<L, C>> lift2either<L, A, B, C>(
        C Function(A a, B b) f) =>
    (Either<L, A> fa, Either<L, B> fb) => map2either(fa, fb, f);

Function3<Either<L, A>, Either<L, B>, Either<L, C>, Either<L, D>>
    lift3either<L, A, B, C, D>(D Function(A a, B b, C c) f) =>
        (Either<L, A> fa, Either<L, B> fb, Either<L, C> fc) =>
            map3either(fa, fb, fc, f);

// // map
// Either<L, B> map1either<L, A, A2 extends A, B>(
//         Either<L, A2> fa, B Function(A a) fun) =>
//     fa.fold(left, (a) => right(fun(a)));

Either<L, C> map2either<L, A, A2 extends A, B, B2 extends B, C>(
        Either<L, A2> fa, Either<L, B2> fb, C Function(A a, B b) fun) =>
    fa.fold(
        left,
        (a) => fb.fold(
            left,
            (b) => right(fun(
                  a,
                  b,
                ))));

Either<L, D> map3either<L, A, A2 extends A, B, B2 extends B, C, C2 extends C,
            D>(Either<L, A2> fa, Either<L, B2> fb, Either<L, C2> fc,
        D Function(A a, B b, C c) fun) =>
    fa.fold(left,
        (a) => fb.fold(left, (b) => fc.fold(left, (c) => right(fun(a, b, c)))));

TaskEither<L, R> taskEitherFlatE<L, R>(Either<L, TaskEither<L, R>> input) =>
    TaskEither.flatten(TaskEither.fromEither(input));
