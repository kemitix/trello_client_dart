import 'package:test/test.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../../cli_commons.dart';

void main() {
  test('requests lists', () async {
    //given
    var boardId = 'my-board-id';
    var args = 'board list-lists $boardId'.split(' ');
    var fakeTrelloClient = createFakeTrelloClient(createResponse(body: []));
    //when
    await app().run(EnvArgsEnvironment(validEnvironment, args,
        (TrelloAuthentication _) => fakeTrelloClient.trelloClient));
    //then
    expect(fakeTrelloClient.fetchHistory.length, 1);
    var requestOptions = fakeTrelloClient.fetchHistory[0].head;
    expect(requestOptions.method, 'GET');
    expect(requestOptions.baseUrl, 'example.com');
    expect(requestOptions.path, '/1/boards/$boardId/lists');
    expect(requestOptions.queryParameters, {
      'bar': 'baz',
      'cards': 'all',
      'card_fields': 'all',
      'filter': 'all',
      'fields': 'id,name,pos,closed,subscribed',
    });
  });
}
