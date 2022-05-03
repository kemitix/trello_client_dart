import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../mocks/dio_mock.dart';

var validEnvironment = <String, String>{
  'TRELLO_USERNAME': 'foo',
  'TRELLO_KEY': 'bar',
  'TRELLO_SECRET': 'baz',
};

ResponseBody createResponse(
    {required Object body,
    int statusCode = 200,
    String contentType = Headers.jsonContentType}) {
  return ResponseBody.fromString(
    body is String ? body : jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [contentType],
    },
  );
}

class FakePrinter {
  final List<String> output = [];
  void Function(Object) get printer =>
      (Object s) => output.addAll(s.toString().split('\n'));
}
