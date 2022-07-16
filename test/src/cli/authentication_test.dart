import 'package:test/test.dart' show expect, fail, test;
import 'package:trello_client/trello_cli.dart' show authentication;
import 'package:trello_client/trello_sdk.dart' show MemberId, TrelloAuthentication;

void main() {
  test('no env set', () {
    authentication({}).fold(
      (l) => expect(l, [
        'Environment not set TRELLO_USERNAME',
        'Environment not set TRELLO_KEY',
        'Environment not set TRELLO_SECRET',
      ]),
      (r) => fail("should have failed"),
    );
  });
  test('all env are set', () {
    authentication({
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
    authentication({
      'TRELLO_KEY': 'key',
      'TRELLO_SECRET': 'secret',
    }).fold(
      (l) => expect(l, ['Environment not set TRELLO_USERNAME']),
      (r) => fail("should have failed"),
    );
  });
  test('username and secret set, but not key', () {
    authentication({
      'TRELLO_USERNAME': 'username',
      'TRELLO_SECRET': 'secret',
    }).fold(
      (l) => expect(l, ['Environment not set TRELLO_KEY']),
      (r) => fail("should have failed"),
    );
  });
  test('username and key set, but not secret', () {
    authentication({
      'TRELLO_USERNAME': 'username',
      'TRELLO_KEY': 'key',
    }).fold(
      (l) => expect(l, ['Environment not set TRELLO_SECRET']),
      (r) => fail("should have failed"),
    );
  });
}
