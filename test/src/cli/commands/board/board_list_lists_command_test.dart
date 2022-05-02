import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../../../mocks/dio_mock.dart';

void main() {
  var authentication =
      TrelloAuthentication.of(MemberId("_memberId"), "_key", "_token");

  var env = <String, String>{
    'TRELLO_USERNAME': 'foo',
    'TRELLO_KEY': 'bar',
    'TRELLO_SECRET': 'baz',
  };

  test('requests lists', () async {
    //given
    var boardId = 'my-board-id';
    var args = 'board list-lists $boardId'.split(' ');
    var response = ResponseBody.fromString(
      jsonEncode([]),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
    TestTrelloClient testClient = testTrelloClient(
        baseUrl: 'example.com',
        queryParameters: {'bar': 'baz'},
        authentication: authentication,
        responses: <ResponseBody>[response]);

    TrelloClient clientFactory(TrelloAuthentication _) =>
        testClient.trelloClient;

    //when
    await app().run(EnvArgsEnvironment(env, args, clientFactory));
    //then
    Tuple2(1, 2);
    expect(testClient.fetchHistory.length, 1);
    var requestOptions = testClient.fetchHistory[0].head;
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
