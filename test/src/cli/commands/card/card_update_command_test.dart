import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../../../mocks/dio_mock.dart';
import '../../cli_commons.dart';

void main() {
  //given
  var cardId = 'my-card-id';
  var client = TestTrelloClient(responses: [
    createResponse(body: {
      'id': 'my-card-id',
      'pos': 'my-pos',
      'name': 'my-card-name',
      'due': '2022-05-05T09:45',
      'idMembers': ['my-member-id'],
    }),
    createResponse(body: {
      'id': 'my-card-id',
      'pos': 'my-pos',
      'name': 'new-name',
      'due': '2022-05-05T09:45',
      'idMembers': ['my-member-id'],
    })
  ]);
  var printer = FakePrinter();
  var environment = EnvArgsEnvironment(
    platformEnvironment: validEnvironment,
    arguments: 'card update $cardId --name new-name'.split(' '),
    clientFactory: (_) => client.trelloClient,
    printer: printer.printer,
  );

  //when
  setUpAll(() => app().run(environment));

  //then
  var history = client.fetchHistory;
  test('there was 1 request', () => expect(history.length, 1));
  test('request was PUT', () => expect(history[0].head.method, 'PUT'));
  test('request path', () => expect(history[0].head.path, '/1/cards/$cardId'));
  test(
      'request content type',
      () => expect(history[0].head.headers[Headers.contentTypeHeader],
          Headers.formUrlEncodedContentType));
  test('request has no query parameters',
      () => expect(history[0].head.queryParameters, {}));
  test('output', () => expect(printer.output, ['Updated']));
}
