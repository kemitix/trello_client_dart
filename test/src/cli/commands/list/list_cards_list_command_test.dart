import 'package:test/test.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../../../mocks/dio_mock.dart';
import '../../cli_commons.dart';

void main() {
  //given
  var listId = 'my-list-id';
  var client = TestTrelloClient(responses: [
    createResponse(body: [{
      'id': 'my-id',
      'name': 'my-card-name',
      'pos': 1000,
      'due': '2020-04-12',
    },])
  ]);
  var printer = FakePrinter();
  var environment = EnvArgsEnvironment(
    platformEnvironment: validEnvironment,
    arguments: 'list list-cards $listId'.split(' '),
    clientFactory: (_) => client.trelloClient,
    printer: printer.printer,
  );

  //when
  setUpAll(() => app().run(environment));

  //then
  var history = client.fetchHistory;
  test('there was one request', () => expect(history.length, 1));
  test('request was GET', () => expect(history[0].head.method, 'GET'));
  test('request path', () => expect(history[0].head.path, '/1/lists/$listId/cards'));
  test('request query parameters',
      () => expect(history[0].head.queryParameters, {
      }));
  test(
      'output',
      () => expect(printer.output, [
        'id    | name         |  pos | due       ',
        '------|--------------|------|-----------',
        'my-id | my-card-name | 1000 | 2020-04-12',
      ]));
}
