import 'package:dartz/dartz.dart';

void main() {
  print("fp play - start");

  Either<dynamic, String> a = right('hello, world!');
  Either<dynamic, List<String>> b = right(['a', 'b']);
  IList<Either<dynamic, String>> c = b.traverseIList((r) => ilist(r));
  Either<dynamic, IList<String>> d = c.traverseEither(id);
  Either<dynamic, IList<String>> e = IList.sequenceEither(c);

  print("fp play - done");
}
