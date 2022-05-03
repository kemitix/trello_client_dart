import 'package:test/test.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../../cli_commons.dart';

void main() {
  var boardId = 'my-board-id';
  var args = 'board list-lists $boardId'.split(' ');
  var fakeTrelloClient = createFakeTrelloClient([createResponse(body: [])]);
  setUpAll(() async => await app().run(EnvArgsEnvironment(validEnvironment,
      args, (TrelloAuthentication _) => fakeTrelloClient.trelloClient)));
  test('there was only one request',
      () => expect(fakeTrelloClient.fetchHistory.length, 1));
  test('request was a GET',
      () => expect(fakeTrelloClient.fetchHistory[0].head.method, 'GET'));
  test(
      'request baseUrl',
      () =>
          expect(fakeTrelloClient.fetchHistory[0].head.baseUrl, 'example.com'));
  test(
      'request path',
      () => expect(fakeTrelloClient.fetchHistory[0].head.path,
          '/1/boards/$boardId/lists'));
  test(
      'requests query parameters',
      () async =>
          expect(fakeTrelloClient.fetchHistory[0].head.queryParameters, {
            'cards': 'all',
            'card_fields': 'all',
            'filter': 'all',
            'fields': 'id,name,pos,closed,subscribed',
          }));
}
