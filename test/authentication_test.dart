import 'package:test/test.dart';
import 'package:trello_sdk/src/cli/authentication.dart';
import 'package:trello_sdk/src/sdk/client.dart';
import 'package:trello_sdk/src/sdk/members/member_models.dart';

void main() {
  test('no env set', () {
    authentication().run({}).fold(
      (l) => expect(l, 'Environment not set TRELLO_USERNAME'),
      (r) => fail("should have failed"),
    );
  });
  test('all env are set', () {
    authentication().run({
      'TRELLO_USERNAME': 'username',
      'TRELLO_KEY': 'key',
      'TRELLO_SECRET': 'secret',
    }).fold(
      (l) => fail("should have succeeded"),
      (r) => expect(
          r, TrelloAuthentication.of(MemberId('username'), 'key', 'secret')),
    );
  });
  test('key and secret set, but not username', () {
    authentication().run({
      'TRELLO_KEY': 'key',
      'TRELLO_SECRET': 'secret',
    }).fold(
      (l) => expect(l, 'Environment not set TRELLO_USERNAME'),
      (r) => fail("should have failed"),
    );
  });
  test('username and secret set, but not key', () {
    authentication().run({
      'TRELLO_USERNAME': 'username',
      'TRELLO_SECRET': 'secret',
    }).fold(
      (l) => expect(l, 'Environment not set TRELLO_KEY'),
      (r) => fail("should have failed"),
    );
  });
  test('username and key set, but not secret', () {
    authentication().run({
      'TRELLO_USERNAME': 'username',
      'TRELLO_KEY': 'key',
    }).fold(
      (l) => expect(l, 'Environment not set TRELLO_SECRET'),
      (r) => fail("should have failed"),
    );
  });
}
