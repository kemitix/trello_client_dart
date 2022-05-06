import 'package:test/test.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../../../mocks/dio_mock.dart';
import '../../cli_commons.dart';

void main() {
  //given
  var memberId = 'my-member-id';
  var client = TestTrelloClient(responses: [
    createResponse(body: [{
      'id': 'my-id',
      'name': 'my-board-name',
      'pinned': false,
      'closed': true,
      'starred': false,
      'shortUrl': 'my-short-url',
    },])
  ]);
  var printer = FakePrinter();
  var environment = EnvArgsEnvironment(
    platformEnvironment: validEnvironment,
    arguments: 'member list-boards $memberId'.split(' '),
    clientFactory: (_) => client.trelloClient,
    printer: printer.printer,
  );

  //when
  setUpAll(() => app().run(environment));

  //then
  var history = client.fetchHistory;
  test('there was one request', () => expect(history.length, 1));
  test('request was GET', () => expect(history[0].head.method, 'GET'));
  test('request path', () => expect(history[0].head.path, '/1/members/$memberId/boards'));
  test('request query parameters',
      () => expect(history[0].head.queryParameters, {
        'filter': 'all',
        'fields': 'id,name,pinned,closed,starred,shortUrl',
      }));
  test(
      'output',
      () => expect(printer.output, [
        'id    | name          | pinned | closed | starred | shortUrl    ',
        '------|---------------|--------|--------|---------|-------------',
        'my-id | my-board-name | false  | true   | false   | my-short-url',
      ]));
}
