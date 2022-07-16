import 'dart:convert' show jsonEncode;

import 'package:dio/dio.dart' show Headers, RequestOptions, ResponseBody;
import 'package:test/test.dart'
    show expect, group, isNotNull, isTrue, setUpAll, test;
import 'package:trello_client/trello_cli.dart' show EnvArgsEnvironment, app;

import '../mocks/dio_mock.dart' show TestTrelloClient;
import '../sdk/sdk_commons.dart' show ExpectedRequest;

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

class CliExpectations {
  CliExpectations({
    required this.requests,
    required this.output,
    required this.help,
    this.notFoundOutput,
    this.serverErrorOutput,
  });

  final List<ExpectedRequest> requests;
  final List<String> output;
  final List<String> help;
  final List<String>? notFoundOutput;
  final List<String>? serverErrorOutput;
}

void cliTest<T>({
  required List<String> arguments,
  required List<ResponseBody> responses,
  required CliExpectations expectations,
  bool testNotFound = true,
  bool testServerError = true,
}) {
  group('validate test - ${arguments.join(' ')}', () {
    test('request count match response count',
        () => expect(expectations.requests.length, responses.length));
  });
  group('${arguments.join(' ')} --help', () {
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
    test('output', () => expect(printer.output, expectations.help));
  });
  group('${arguments.join(' ')} (200 Okay)', () {
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
      test(
          'expected number of requests',
          () =>
              expect(client.fetchHistory.length, expectations.requests.length));
      var count = 0;
      for (var expectedRequest in expectations.requests) {
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
    test('output', () => expect(printer.output, expectations.output));
  });
  if (testNotFound && expectations.requests.isNotEmpty) {
    test(
        'expected output for Not Found Error provided',
        () => expect(expectations.notFoundOutput, isNotNull,
            reason:
                'try "testNotFound: false" or supply "expectedNotFoundOutput"'));
    if (expectations.notFoundOutput != null &&
        expectations.requests.isNotEmpty) {
      group('${arguments.join(' ')} (404 Not Found)', () {
        //given
        var printer = FakePrinter();
        var client = TestTrelloClient(
            responses: [createResponse(statusCode: 404, body: {})]);
        var envArgsEnvironment = EnvArgsEnvironment(
            platformEnvironment: validEnvironment,
            arguments: arguments,
            clientFactory: (_) => client.trelloClient,
            printer: printer.printer);
        //when
        setUpAll(() async => await app().run(envArgsEnvironment));
        //then
        test('expected number of requests',
            () => expect(client.fetchHistory.length, 1));
        test('output',
            () => expect(printer.output, expectations.notFoundOutput));
      });
    }
  }
  if (testServerError && expectations.requests.isNotEmpty) {
    test(
        'expected output for Server Error provided',
        () => expect(expectations.serverErrorOutput, isNotNull,
            reason:
                'try "testServerError: false" or supply "expectedServerErrorOutput"'));
    if (expectations.serverErrorOutput != null) {
      group('${arguments.join(' ')} (500 Server Error)', () {
        //given
        var printer = FakePrinter();
        var client = TestTrelloClient(
            responses: [createResponse(statusCode: 500, body: {})]);
        var envArgsEnvironment = EnvArgsEnvironment(
            platformEnvironment: validEnvironment,
            arguments: arguments,
            clientFactory: (_) => client.trelloClient,
            printer: printer.printer);
        //when
        setUpAll(() async => await app().run(envArgsEnvironment));
        //then
        test('expected number of requests',
            () => expect(client.fetchHistory.length, 1));
        test('output',
            () => expect(printer.output, expectations.serverErrorOutput));
      });
    }
  }
}
