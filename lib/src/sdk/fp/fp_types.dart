typedef Function1<A, B> = B Function(A a);
typedef Function2<A, B, C> = C Function(A a, B b);
typedef Function3<A, B, C, D> = D Function(A a, B b, C c);

class Tuple3<A, B, C> {
  Tuple3(this.a, this.b, this.c);
  final A a;
  final B b;
  final C c;
}
