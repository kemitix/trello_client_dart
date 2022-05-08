import '../fp/fp.dart';

class TaskEither<L, R> {
  /// Build a [TaskEither] from a function returning a `Future<Either<L, R>>`.
  const TaskEither(this._run);
  final Future<Either<L, R>> Function() _run;

  /// Run the task and return a `Future<Either<L, R>>`.
  Future<Either<L, R>> run() => _run();

  /// Pattern matching to convert a [TaskEither] to a [Task].
  ///
  /// Execute `onLeft` when running this [TaskEither] returns a [Left].
  /// Otherwise execute `onRight`.
  Task<A> match<A>(A Function(L l) onLeft, A Function(R r) onRight) =>
      Task(() async => (await run()).fold(onLeft, onRight));

  /// Apply the function contained inside `a` to change the value on the [Right] from
  /// type `R` to a value of type `C`.
  @override
  TaskEither<L, C> ap<C>(covariant TaskEither<L, C Function(R r)> a) =>
      a.flatMap((f) => flatMap((v) => pure(f(v))));

  /// Returns a [TaskEither] that returns a `Right(a)`.
  @override
  TaskEither<L, C> pure<C>(C a) => TaskEither(() async => Right(a));

  /// Used to chain multiple functions that return a [TaskEither].
  ///
  /// You can extract the value of every [Right] in the chain without
  /// handling all possible missing cases.
  /// If running any of the tasks in the chain returns [Left], the result is [Left].
  @override
  TaskEither<L, C> flatMap<C>(covariant TaskEither<L, C> Function(R r) f) =>
      TaskEither(() => run().then(
            (either) async => either.fold(
              left,
              (r) => f(r).run(),
            ),
          ));

  /// If running this [TaskEither] returns [Right], then change its value from type `R` to
  /// type `C` using function `f`.
  @override
  TaskEither<L, C> map<C>(C Function(R r) f) => ap(pure(f));

  /// Flat a [TaskEither] contained inside another [TaskEither] to be a single [TaskEither].
  factory TaskEither.flatten(TaskEither<L, TaskEither<L, R>> taskEither) =>
      taskEither.flatMap(identity);

  /// Build a [TaskEither] that returns `either`.
  factory TaskEither.fromEither(Either<L, R> either) =>
      TaskEither(() async => either);

  /// Build a [TaskEither] that returns a `Left(left)`.
  factory TaskEither.left(L left) => TaskEither(() async => Left(left));

  /// If `f` applied on this [TaskEither] as [Right] returns `true`, then return this [TaskEither].
  /// If it returns `false`, return the result of `onFalse` in a [Left].
  TaskEither<L, R> filterOrElse(
          bool Function(R r) f, L Function(R r) onFalse) =>
      flatMap((r) => f(r) ? TaskEither.of(r) : TaskEither.left(onFalse(r)));

  /// Build a [TaskEither] that returns a `Right(r)`.
  ///
  /// Same of `TaskEither.right`.
  factory TaskEither.of(R r) => TaskEither(() async => Right(r));

  /// Change the value in the [Left] of [TaskEither].
  TaskEither<C, R> mapLeft<C>(C Function(L l) f) => TaskEither(
      () async => (await run()).fold((l) => Left(f(l)), (r) => Right(r)));

  /// Build a [TaskEither] from the result of running `task`.
  ///
  /// Same of `TaskEither.rightTask`
  factory TaskEither.fromTask(Task<R> task) =>
      TaskEither(() async => Right(await task.run()));

  /// Define two functions to change both the [Left] and [Right] value of the
  /// [TaskEither].
  ///
  /// Same as `map`+`mapLeft` but for both [Left] and [Right]
  /// (`map` is only to change [Right], while `mapLeft` is only to change [Left]).
  TaskEither<C, D> bimap<C, D>(
          C Function(L l) mapLeft, D Function(R r) mapRight) =>
      map(mapRight).mapLeft(mapLeft);
}

TaskEither<dynamic, V> attemptTask<V>(Future<V> Function() action) {
  return TaskEither.flatten(TaskEither.fromTask(
      Task(() => action()).attempt().map((e) => TaskEither.fromEither(e))));
}
