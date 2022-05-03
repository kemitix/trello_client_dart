import 'package:test/test.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../../cli_commons.dart';

void main() {
  var boardId = 'my-board-id';
  var args = 'board list-lists $boardId'.split(' ');
  var fakeTrelloClient = createFakeTrelloClient([createResponse(body: [])]);
  var fetchHistory = fakeTrelloClient.fetchHistory;
  setUpAll(() async => await app().run(EnvArgsEnvironment(validEnvironment,
      args, (TrelloAuthentication _) => fakeTrelloClient.trelloClient)));
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
}
