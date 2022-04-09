void main(List<String> arguments) => parseArgs(arguments).fold(
      onLeft: (errors) => reportErrors(errors),
      onRight: (keys) => runApp(keys),
    );

void runApp(Keys keys) {}

void reportErrors(ErrorList errors) {
  errors.forEach((error) {
    print(error);
  });
}

typedef Supplier<T> = T Function();

Either<ErrorList, Keys> parseArgs(List<String> arguments) {
  return Left.of(['parseArgs: No Implemented']);
}

typedef Consumer<T> = void Function(T);

abstract class Either<L, R> {
  void fold({required Consumer<L> onLeft, required Consumer<R> onRight});
}

class Left<L, R> extends Either<L, R> {
  L _error;
  Left.of(this._error);
  @override
  void fold({required Consumer<L> onLeft, required Consumer<R> onRight}) {
    onLeft.call(_error);
  }
}

class Right<L, R> extends Either<L, R> {
  R _value;
  Right.of(this._value);
  @override
  void fold({required Consumer<L> onLeft, required Consumer<R> onRight}) {
    onRight.call(_value);
  }
}

typedef ErrorList = List<Error>;

typedef Error = String;

class Keys {
  String _key;
  String get key => _key;

  String _secret;
  String get secret => _secret;

  Keys.of(this._key, this._secret);
}
