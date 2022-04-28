import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../../../mocks/dio_mock.dart';

void main() {
  var authentication =
      TrelloAuthentication.of(MemberId("_memberId"), "_key", "_token");

  test('requests lists', () async {
    //given
    var boardId = 'my-board-id';
    var response = ResponseBody.fromString(
      jsonEncode([]),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
    var testClient = testTrelloClient(
        baseUrl: 'example.com',
        queryParameters: {'bar': 'baz'},
        authentication: authentication,
        responses: <ResponseBody>[response]);
    var commandRunner = runner(testClient.trelloClient);
    //when
    await commandRunner.run(['board', 'list-lists', boardId]);
    //then
    Tuple2(1, 2);
    expect(testClient.fetchHistory.length, 1);
    var requestOptions = testClient.fetchHistory[0].a;
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
