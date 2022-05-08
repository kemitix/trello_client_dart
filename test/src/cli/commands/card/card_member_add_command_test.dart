import 'package:test/test.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../../../mocks/dio_mock.dart';
import '../../cli_commons.dart';

void main() {
  group('add new member to card', () {
    //given
    var cardId = 'my-card-id';
    var memberId = 'my-member-id';
    var client = TestTrelloClient(responses: [
      createResponse(body: {
        'id': 'my-card-id',
        'pos': 'my-pos',
        'name': 'my-card-name',
        'due': '2022-05-05T09:45',
        'idMembers': [],
      }),
      createResponse(body: {})
    ]);
    var printer = FakePrinter();
    var environment = EnvArgsEnvironment(
      platformEnvironment: validEnvironment,
      arguments: 'card add-member $cardId $memberId'.split(' '),
      clientFactory: (_) => client.trelloClient,
      printer: printer.printer,
    );

    //when
    setUpAll(() => app().run(environment));

    //then
    var history = client.fetchHistory;
    test('there were two requests', () => expect(history.length, 2));

    test('first request was GET', () => expect(history[0].head.method, 'GET'));
    test('first request path',
        () => expect(history[0].head.path, '/1/cards/$cardId'));
    test('first request query parameters',
        () => expect(history[0].head.queryParameters, {'fields': 'idMembers'}));

    test('second request was POST',
        () => expect(history[1].head.method, 'POST'));
    test('second request path',
        () => expect(history[1].head.path, '/1/cards/$cardId/idMembers'));
    test('second request query parameters',
        () => expect(history[1].head.queryParameters, {'value': memberId}));

    test('output', () => expect(printer.output, ['Added member']));
  });
  group('do not add existing member to card', () {
    //given
    var cardId = 'my-card-id';
    var memberId = 'my-member-id';
    var client = TestTrelloClient(responses: [
      createResponse(body: {
        'id': 'my-card-id',
        'pos': 'my-pos',
        'name': 'my-card-name',
        'due': '2022-05-05T09:45',
        'idMembers': ['my-member-id'],
      })
    ]);
    var printer = FakePrinter();
    var environment = EnvArgsEnvironment(
      platformEnvironment: validEnvironment,
      arguments: 'card add-member $cardId $memberId'.split(' '),
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
        'request path', () => expect(history[0].head.path, '/1/cards/$cardId'));
    test('request query parameters',
        () => expect(history[0].head.queryParameters, {'fields': 'idMembers'}));

    test(
        'output',
        () => expect(printer.output, [
              'ERROR: card add-member - Failure: Can\'t Add a Member to a Card as it is already applied'
            ]));
  });
}
