import 'package:test/test.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../../../mocks/dio_mock.dart';
import '../../cli_commons.dart';

void main() {
  group('board list-lists', () {
    //given
    var boardId = 'my-board-id';
    var client = TestTrelloClient(baseUrl: 'example.com', responses: [
      createResponse(body: [
        {
          'id': 'my-list-id',
          'name': 'my-list-name',
          'pos': 1024,
          'closed': false,
          'subscribed': true,
        }
      ])
    ]);
    var printer = FakePrinter();
    var environment = EnvArgsEnvironment(
      platformEnvironment: validEnvironment,
      arguments: 'board list-lists $boardId'.split(' '),
      clientFactory: (_) => client.trelloClient,
      printer: printer.printer,
    );

    //when
    setUpAll(() => app().run(environment));

    //then
    var fetchHistory = client.fetchHistory;
    test('there was only one request', () => expect(fetchHistory.length, 1));
    test('request was a GET', () => expect(fetchHistory[0].head.method, 'GET'));
    test('request baseUrl',
        () => expect(fetchHistory[0].head.baseUrl, 'example.com'));
    test('request path',
        () => expect(fetchHistory[0].head.path, '/1/boards/$boardId/lists'));
    test(
        'requests query parameters',
        () async => expect(fetchHistory[0].head.queryParameters, {
              'cards': 'all',
              'card_fields': 'all',
              'filter': 'all',
              'fields': 'id,name,pos,closed,subscribed',
            }));
    test(
        'output',
        () async => expect(printer.output, [
              'id         | name         |  pos | closed | subscribed',
              '-----------|--------------|------|--------|-----------',
              'my-list-id | my-list-name | 1024 | false  | true      ',
            ]));
  });
  group('board list-lists --fields', () {
    //given
    var boardId = 'my-board-id';
    var client = TestTrelloClient(baseUrl: 'example.com', responses: [
      createResponse(body: [
        {
          'id': 'my-list-id',
          'name': 'my-list-name',
          'pos': 1024,
          'closed': false,
          'subscribed': true,
        }
      ])
    ]);
    var printer = FakePrinter();
    var environment = EnvArgsEnvironment(
      platformEnvironment: validEnvironment,
      arguments: 'board list-lists --fields id,name $boardId'.split(' '),
      clientFactory: (_) => client.trelloClient,
      printer: printer.printer,
    );

    //when
    setUpAll(() => app().run(environment));

    //then
    var fetchHistory = client.fetchHistory;
    test('there was only one request', () => expect(fetchHistory.length, 1));
    test('request was a GET', () => expect(fetchHistory[0].head.method, 'GET'));
    test('request baseUrl',
        () => expect(fetchHistory[0].head.baseUrl, 'example.com'));
    test('request path',
        () => expect(fetchHistory[0].head.path, '/1/boards/$boardId/lists'));
    test(
        'requests query parameters',
        () async => expect(fetchHistory[0].head.queryParameters, {
              'cards': 'all',
              'card_fields': 'all',
              'filter': 'all',
              'fields': 'id,name',
            }));
    test(
        'output',
        () async => expect(printer.output, [
              'id         | name        ',
              '-----------|-------------',
              'my-list-id | my-list-name',
            ]));
  });
  group('help output', () {
    //given
    var arguments = 'board list-lists --help'.split(' ');

    var printer = FakePrinter();
    var envArgsEnvironment = EnvArgsEnvironment(
        platformEnvironment: validEnvironment,
        arguments: arguments,
        clientFactory: (_) => TestTrelloClient(responses: []).trelloClient,
        printer: printer.printer);
    //when
    setUpAll(() async => await app().run(envArgsEnvironment));
    //then
    test(
        'output',
        () => expect(printer.output, [
              'Get Lists on a Board',
              '',
              'Usage: trello board list-lists [arguments]',
              '-h, --help      Print this usage information.',
              '    --fields    all or a comma-separated list of fields',
              '                (defaults to "id,name,pos,closed,subscribed")',
              '',
              'Run "trello help" to see global options.'
            ]));
  });
  group('board id not given', () {
    //given
    var arguments = 'board list-lists'.split(' ');

    var printer = FakePrinter();
    var envArgsEnvironment = EnvArgsEnvironment(
        platformEnvironment: validEnvironment,
        arguments: arguments,
        clientFactory: (_) => TestTrelloClient(responses: []).trelloClient,
        printer: printer.printer);
    //when
    setUpAll(() async => await app().run(envArgsEnvironment));
    //then
    test(
        'output',
        () => expect(printer.output,
            ['ERROR: board list-lists - Failure: Board Id not given']));
  });
}
