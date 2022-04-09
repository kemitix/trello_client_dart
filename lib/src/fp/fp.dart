export 'either.dart';

typedef Fn<A, B> = B Function(A);

typedef Consumer<T> = void Function(T);

typedef Supplier<T> = T Function();
