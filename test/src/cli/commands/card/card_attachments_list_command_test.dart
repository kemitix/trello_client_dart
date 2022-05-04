import 'package:test/test.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../../../mocks/dio_mock.dart';
import '../../cli_commons.dart';

void main() {
  //given
  var cardId = 'my-card-id';
  var client = TestTrelloClient(
      authentication:
          TrelloAuthentication.of(MemberId("_memberId"), "_key", "_token"),
      responses: [
        createResponse(body: [
          {
            'id': 'my-card-id',
            'name': 'my-card-name',
            'mimeType': 'my-mime-type',
            'bytes': 100,
          }
        ])
      ]);
  var printer = FakePrinter();
  var environment = EnvArgsEnvironment(
    platformEnvironment: validEnvironment,
    arguments: 'card list-attachments $cardId'.split(' '),
    clientFactory: (_) => client.trelloClient,
    printer: printer.printer,
  );

  //when
  setUpAll(() => app().run(environment));

  //then
  var history = client.fetchHistory;
  test('there was one request', () => expect(history.length, 1));
  test('request was GET', () => expect(history[0].head.method, 'GET'));
  test('request path',
      () => expect(history[0].head.path, '/1/cards/$cardId/attachments'));
  test(
      'request query parameters',
      () => expect(history[0].head.queryParameters,
          {'filter': 'false', 'fields': 'id,name,mimeType,bytes'}));
  test(
      'output',
      () => expect(printer.output, [
            'id         | name         | mimeType     | bytes',
            '-----------|--------------|--------------|------',
            'my-card-id | my-card-name | my-mime-type |   100',
          ]));
}
