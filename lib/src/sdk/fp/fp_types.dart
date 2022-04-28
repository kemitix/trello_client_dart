/// Returns the given `a`.
///
/// Same as `id`.
///
/// Shortcut function to return the input parameter:
/// ```dart
/// final either = Either<String, int>.of(10);
///
/// /// Without using `identity`, you must write a function to return
/// /// the input parameter `(l) => l`.
/// final noId = either.match((l) => l, (r) => '$r');
///
/// /// Using `identity`/`id`, the function just returns its input parameter.
/// final withIdentity = either.match(identity, (r) => '$r');
/// final withId = either.match(id, (r) => '$r');
/// ```
T identity<T>(T a) => a;
