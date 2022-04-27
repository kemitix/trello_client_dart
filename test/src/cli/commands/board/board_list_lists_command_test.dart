import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:dio/dio.dart';
import 'package:test/scaffolding.dart';
import 'package:test/test.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../../../mocks/dio_mock.dart';

const dioHttpHeadersForResponseBody = {
  Headers.contentTypeHeader: [Headers.jsonContentType],
};

/// https://gist.github.com/hjJunior/1ea524be7f0d09e5b1639e46560f44f0
///
void main() {
  var authentication =
      TrelloAuthentication.of(MemberId("_memberId"), "_key", "_token");

  test('requests lists', () async {
    //given
    var boardId = 'my-board-id';
    var response = ResponseBody.fromString(
      jsonEncode([]),
      200,
      headers: dioHttpHeadersForResponseBody,
    );
    var testClient = testTrelloClient(
        baseUrl: '/foo',
        queryParameters: {'bar': 'baz'},
        authentication: authentication,
        responses: <ResponseBody>[response]);
    CommandRunner commandRunner = runner(testClient.trelloClient);
    //when
    await commandRunner.run(['board', 'list-lists', 'my-board-id']);
    //then
    expect(testClient.fetchHistory.length, 1);
    var requestOptions = testClient.fetchHistory[0].head;
    expect(requestOptions.method, 'GET');
    expect(requestOptions.path, '/1/boards/$boardId/lists');
    expect(requestOptions.queryParameters, {
      'cards': 'all',
      'card_fields': 'all',
      'filter': 'all',
      'fields': 'id,name,pos,closed,subscribed',
    });
  });
}
