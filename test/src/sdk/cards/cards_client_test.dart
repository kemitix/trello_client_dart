import 'package:test/test.dart';
import 'package:trello_sdk/src/sdk/cards/cards.dart';

import '../../cli/cli_commons.dart';
import '../sdk_commons.dart';

void main() {
  //get
  group('card get', () {
    apiTest<TrelloCard>(
        apiCall: (client) =>
            client.trelloClient.card(CardId('my-card-id')).get(),
        expectedMethod: 'GET',
        expectedPath: '/1/cards/my-card-id',
        expectedQueryParameters: {'fields': 'all'},
        existingResourceResponse: createResponse(body: {
          'id': 'my-card-id',
          'name': 'my-card-name',
        }),
        responseValues: [
          testValue('id', (r) => r.id, CardId('my-card-id')),
          testValue('name', (r) => r.name, 'my-card-name'),
        ],
        additionalContext: {});
  });
  //put
  //addMember
  //attachments
  //attachment
}
