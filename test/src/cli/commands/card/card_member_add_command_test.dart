import 'package:test/test.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../../../mocks/dio_mock.dart';
import '../../cli_commons.dart';

void main() {
  //given
  var cardId = 'my-card-id';
  var client = fakeTrelloClient(
      baseUrl: 'example.com',
      queryParameters: {},
      authentication:
          TrelloAuthentication.of(MemberId("_memberId"), "_key", "_token"),
      responses: [
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
    arguments: 'card get $cardId'.split(' '),
    clientFactory: (_) => client.trelloClient,
    printer: printer.printer,
  );

  //when
  setUpAll(() => app().run(environment));

  //then
  var history = client.fetchHistory;
  test('there was one request', () => expect(history.length, 1));
  test('request was GET', () => expect(history[0].head.method, 'GET'));
  test('request path', () => expect(history[0].head.path, '/1/cards/$cardId'));
  test('request query parameters',
      () => expect(history[0].head.queryParameters, {'fields': 'all'}));
  test(
      'output',
      () => expect(printer.output, [
            'id        | my-card-id      ',
            'name      | my-card-name    ',
            'pos       | my-pos          ',
            'due       | 2022-05-05T09:45',
            'idMembers | [my-member-id]  '
          ]));
}
