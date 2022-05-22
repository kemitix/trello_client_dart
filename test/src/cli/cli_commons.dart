import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../mocks/dio_mock.dart';
import '../sdk/sdk_commons.dart';

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

void cliTest<T>({
  required List<String> arguments,
  required List<ExpectedRequest> expectedRequests,
  required List<ResponseBody> responses,
  required List<String> expectedOutput,
  required List<String> expectedHelp,
  bool testNotFound = true,
  bool testUnknownError = true,
}) {
  group('validate test', () {
    test('request count match response count',
        () => expect(expectedRequests.length, responses.length));
  });
  group('--help', () {
    //given
    var printer = FakePrinter();
    var client = TestTrelloClient(responses: responses);
    var envArgsEnvironment = EnvArgsEnvironment(
        platformEnvironment: validEnvironment,
        arguments: [...arguments, '--help'],
        clientFactory: (_) => client.trelloClient,
        printer: printer.printer);
    //when
    setUpAll(() => app().run(envArgsEnvironment));
    //then
    test('there were no requests',
        () => expect(client.fetchHistory.isEmpty, isTrue));
    test('output', () => expect(printer.output, expectedHelp));
  });
  group('exists', () {
    //given
    var printer = FakePrinter();
    var client = TestTrelloClient(responses: responses);
    var envArgsEnvironment = EnvArgsEnvironment(
        platformEnvironment: validEnvironment,
        arguments: arguments,
        clientFactory: (_) => client.trelloClient,
        printer: printer.printer);
    //when
    setUpAll(() async => await app().run(envArgsEnvironment));
    //then
    group('requests', () {
      test('expected number of requests',
          () => expect(client.fetchHistory.length, expectedRequests.length));
      var count = 0;
      for (var expectedRequest in expectedRequests) {
        count++;
        group('request $count', () {
          var myCount = count;
          late RequestOptions request;
          setUpAll(() {
            if (client.fetchHistory.length >= myCount) {
              request = client.fetchHistory[myCount - 1].head;
            }
          });
          test('got request $count', () => expect(request, isNotNull));
          test('method',
              () => expect(request.method, expectedRequest.expectedMethod));
          test(
              'path', () => expect(request.path, expectedRequest.expectedPath));
          test(
              'query parameters',
              () => expect(request.queryParameters,
                  expectedRequest.expectedQueryParameters));
          test('headers',
              () => expect(request.headers, expectedRequest.expectedHeaders));
        });
      }
    });
    test('output', () => expect(printer.output, expectedOutput));
  });
}
