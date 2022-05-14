import 'dart:io';

import 'package:test/test.dart';
import 'package:trello_sdk/src/sdk/fp/fp.dart';

void main() {
  test('TaskEither.attempt catches thrown exception', () async {
    //given
    Future<int> action() async {
      throw SocketException('bar');
    }

    late final TaskEither<String, int> result;
    //when

    result = TaskEither.attempt(action).mapLeft((l) => "Foo: $l");

    //then
    try {
      Either<String, int> outcome = await result.run();
      outcome.fold((l) => expect(l, 'Foo: SocketException: bar'),
          (r) => fail('should have failed'));
    } on Exception catch (ex) {
      fail('Not caught: $ex');
    }
  });
}
