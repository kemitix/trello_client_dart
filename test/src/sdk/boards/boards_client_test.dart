import 'package:test/test.dart';
import 'package:trello_sdk/src/sdk/boards/board_models.dart';
import 'package:trello_sdk/src/sdk/lists/list_models.dart';

import '../../cli/cli_commons.dart';
import '../sdk_commons.dart';

void main() {
  group('board lists', () {
    apiTest<List<TrelloList>>(
        apiCall: (client) =>
            client.trelloClient.board(BoardId('my-board-id')).getLists(),
        expectedMethod: 'GET',
        expectedPath: '/1/boards/my-board-id/lists',
        expectedQueryParameters: {
          'cards': 'all',
          'card_fields': 'all',
          'filter': 'all',
          'fields': 'all'
        },
        existingResourceResponse: createResponse(body: [
          {
            'id': 'my-list-id',
            'name': 'my-list-name',
            'closed': true,
            'idBoard': 'my-board-id',
            'pos': 2000,
            'subscribed': true,
          }
        ]),
        expectedHeaders: {},
        responseValues: [
          testValue('id', (r) => r[0].id, ListId('my-list-id')),
          testValue('name', (r) => r[0].name, 'my-list-name'),
          testValue('closed', (r) => r[0].closed, isTrue),
          testValue('idBoard', (r) => r[0].idBoard, BoardId('my-board-id')),
          testValue('pos', (r) => r[0].pos, 2000),
          testValue('subscribed', (r) => r[0].subscribed, isTrue),
        ],
        additionalContext: {'boardId': 'my-board-id'});
  });
}
