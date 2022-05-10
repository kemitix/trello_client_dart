import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:trello_sdk/src/sdk/errors.dart';
import 'package:trello_sdk/src/sdk/extensions/list_extensions.dart';
import 'package:trello_sdk/src/sdk/fp/fp_task_either.dart';

import '../cli/cli_commons.dart';
import '../mocks/dio_mock.dart';

void verify<V>(Either<Failure, V> value, void Function(V) fn) {
  value.fold((l) => fail('should have succeeded'), (r) => fn(r));
}

class TestResponseValue<T> {
  TestResponseValue(this._name, this._extract, this._expectedValue);

  final String _name;
  final dynamic Function(T) _extract;
  final dynamic _expectedValue;

  String get name => _name;

  dynamic Function(T) get get => _extract;

  dynamic get expected => _expectedValue;
}

TestResponseValue<T> testValue<T>(
        String name, dynamic Function(T) get, dynamic expected) =>
    TestResponseValue(name, get, expected);

void apiTest<T>({
  required TaskEither<Failure, T> Function(TestTrelloClient) apiCall,
  required String expectedMethod,
  required String expectedPath,
  required Map<String, String> expectedQueryParameters,
  required ResponseBody existingResourceResponse,
  required List<TestResponseValue<T>> responseValues,
  required Map<String, String> additionalContext,
  required Map<String, String> expectedHeaders,
}) {
  group('exists', () {
    //given
    var client = TestTrelloClient(responses: [existingResourceResponse]);
    late final Either<Failure, T> response;

    //when
    setUpAll(() async => response = await apiCall(client).run());

    //then
    group('request', () {
      var request;
      setUpAll(() {
        if (client.fetchHistory.isNotEmpty) {
          var firstFetch = client.fetchHistory.head;
          if (firstFetch != null) {
            request = firstFetch.head;
          }
        }
      });
      test(
          'there was one request', () => expect(client.fetchHistory.length, 1));
      test('got first request', () => expect(request, isNotNull));
      test('method', () => expect(request.method, expectedMethod));
      test('path', () => expect(request.path, expectedPath));
      test('query parameters',
          () => expect(request.queryParameters, expectedQueryParameters));
      test('headers', () => expect(request.headers, expectedHeaders));
    });
    group('response', () {
      responseValues.forEach((element) => test('property ${element.name}', () {
            verify<T>(response,
                (resource) => expect(element.get(resource), element.expected));
          }));
    });
  });
  group('not found', () {
    //given
    var missingResponse = createResponse(statusCode: 404, body: {});
    var client = TestTrelloClient(responses: [missingResponse]);
    late final Either<Failure, T> response;

    //when
    setUpAll(() async => response = await apiCall(client).run());

    //then
    group('request', () {
      var request;
      test(
          'there was one request', () => expect(client.fetchHistory.length, 1));
      setUp(() {
        request = client.fetchHistory.head!.head;
      });
      test('got first request', () => expect(request, isNotNull));
      test('method', () => expect(request.method, expectedMethod));
      test('path', () => expect(request.path, expectedPath));
      test('query parameters',
          () => expect(request.queryParameters, expectedQueryParameters));
    });
    group('response', () {
      test(
          'status code',
          () async => response.fold(
                (l) => expect(
                    l.toString(),
                    ResourceNotFoundFailure(resource: expectedPath)
                        .withContext(additionalContext)
                        .toString()),
                (r) => fail('should have failed'),
              ));
    });
  });
  group('unknown error', () {
    //given
    var missingResponse = createResponse(statusCode: 500, body: {});
    var client = TestTrelloClient(responses: [missingResponse]);
    late final Either<Failure, T> response;

    //when
    setUpAll(() async => response = await apiCall(client).run());

    //then
    group('request', () {
      var request;
      test(
          'there was one request', () => expect(client.fetchHistory.length, 1));
      setUp(() {
        request = client.fetchHistory.head!.head;
      });
      test('got first request', () => expect(request, isNotNull));
      test('method', () => expect(request.method, expectedMethod));
      test('path', () => expect(request.path, expectedPath));
      test('query parameters',
          () => expect(request.queryParameters, expectedQueryParameters));
    });
    group('response', () {
      test(
          'status code',
          () async => response.fold(
                (l) => expect(
                    l.toString(),
                    HttpClientFailure(message: '$expectedMethod $expectedPath')
                        .withContext(additionalContext)
                        .toString()),
                (r) => fail('should have failed'),
              ));
    });
  });
}
