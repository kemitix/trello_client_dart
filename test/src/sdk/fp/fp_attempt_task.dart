import 'package:test/test.dart';
import 'package:trello_sdk/src/sdk/fp/fp.dart';

void main() {
  test('attemptTask catches thrown exception', () async {
    //given
    Future<int> action() async {
      throw Exception('bar');
    }

    late final TaskEither<String, int> result;
    //when

    result = attemptTask(action).mapLeft((l) => "Foo: ${l.message}");

    //then
    try {
      Either<String, int> outcome = await result.run();
      outcome.fold(
          (l) => expect(l, 'Foo: bar'), (r) => fail('should have failed'));
    } on Exception catch (ex) {
      fail('Not caught: $ex');
    }
  });
}
