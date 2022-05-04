import 'package:test/test.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../../../mocks/dio_mock.dart';
import '../../cli_commons.dart';

void main() {
  //given
  var cardId = 'my-card-id';
  var attachmentId = 'my-attachment-id';
  var cardName = 'my-card-name';
  var mimeType = 'my-mime-type';
  var bytes = 100;
  var url = 'my-url';
  var client = TestTrelloClient(responses: [
    createResponse(body: {
      'id': cardId,
      'name': cardName,
      'mimeType': mimeType,
      'bytes': bytes,
      'url': url,
    })
  ]);
  var printer = FakePrinter();
  var environment = EnvArgsEnvironment(
    platformEnvironment: validEnvironment,
    arguments: 'card get-attachment $cardId $attachmentId'.split(' '),
    clientFactory: (_) => client.trelloClient,
    printer: printer.printer,
  );

  //when
  setUpAll(() => app().run(environment));

  //then
  var history = client.fetchHistory;
  test('there was one request', () => expect(history.length, 1));
  test('request was GET', () => expect(history[0].head.method, 'GET'));
  test(
      'request path',
      () => expect(
          history[0].head.path, '/1/cards/$cardId/attachments/$attachmentId'));
  test('request has no query parameters',
      () => expect(history[0].head.queryParameters, {}));
  test(
      'output',
      () => expect(printer.output, [
            'id       | my-card-id  ',
            'name     | my-card-name',
            'mimeType | my-mime-type',
            'bytes    | 100         ',
            'url      | my-url      ',
          ]));
}
