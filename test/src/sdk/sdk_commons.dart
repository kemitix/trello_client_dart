import 'package:dartz/dartz.dart';
import 'package:test/test.dart';
import 'package:trello_sdk/src/sdk/errors.dart';

void verify<V>(Either<Failure, V> value, void Function(V) fn) {
  value.fold((l) => fail('should have succeeded'), (r) => fn(r));
}
