import 'package:dio/dio.dart';
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
        expectedHeaders: {},
        responseValues: [
          testValue('id', (r) => r.id, CardId('my-card-id')),
          testValue('name', (r) => r.name, 'my-card-name'),
        ],
        additionalContext: {});
  });
  //put
  group('card put', () {
    var body = 'name=my-new-card-name&desc=my-new-card-desc';
    apiTest<TrelloCard>(
        apiCall: (client) =>
            client.trelloClient.card(CardId('my-card-id')).put(body),
        expectedMethod: 'PUT',
        expectedPath: '/1/cards/my-card-id',
        expectedHeaders: {
          Headers.contentTypeHeader: Headers.formUrlEncodedContentType,
          Headers.contentLengthHeader: body.length.toString(),
        },
        expectedQueryParameters: {},
        existingResourceResponse: createResponse(body: {
          'id': 'my-card-id',
          'name': 'my-new-card-name',
          'desc': 'my-new-card-desc',
        }),
        responseValues: [
          testValue('id', (r) => r.id, CardId('my-card-id')),
          testValue('name', (r) => r.name, 'my-new-card-name'),
          testValue('desc', (r) => r.desc, 'my-new-card-desc'),
        ],
        additionalContext: {});
  });
  //addMember
  //attachments
  //attachment
}
