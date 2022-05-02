import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../mocks/dio_mock.dart';

var validEnvironment = <String, String>{
  'TRELLO_USERNAME': 'foo',
  'TRELLO_KEY': 'bar',
  'TRELLO_SECRET': 'baz',
};

TestTrelloClient createFakeTrelloClient(ResponseBody responseBody) =>
    testTrelloClient(
        baseUrl: 'example.com',
        queryParameters: {'bar': 'baz'},
        authentication:
            TrelloAuthentication.of(MemberId("_memberId"), "_key", "_token"),
        responses: <ResponseBody>[responseBody]);

ResponseBody createResponse(
    {required Object body,
    int statusCode = 200,
    String contentType = Headers.jsonContentType}) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [contentType],
    },
  );
}
