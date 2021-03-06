import 'package:dio/dio.dart' show RequestOptions, ResponseBody;
import 'package:test/test.dart'
    show expect, fail, group, isNotNull, setUp, setUpAll, test;
import 'package:trello_client/trello_sdk.dart'
    show Either, HttpClientFailure, ResourceNotFoundFailure, left, right;

import '../cli/cli_commons.dart' show createResponse;
import '../mocks/dio_mock.dart' show TestTrelloClient;

void verify<V>(Future<V> value, void Function(V) fn) => value
    .onError((error, stackTrace) => fail('should have succeeded'))
    .then((r) => fn(r));

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

class ExpectedRequest {
  String expectedMethod;
  String expectedPath;
  Map<String, String> expectedHeaders;
  Map<String, String> expectedQueryParameters;

  ExpectedRequest({
    required this.expectedMethod,
    required this.expectedPath,
    required this.expectedHeaders,
    required this.expectedQueryParameters,
  });
}

class ExpectedRequestWithResponseTests<T> extends ExpectedRequest {
  ResponseBody existingResourceResponse;
  List<TestResponseValue<T>> responseValues;
  Map<String, String> additionalContext;

  ExpectedRequestWithResponseTests({
    required super.expectedMethod,
    required super.expectedPath,
    required super.expectedHeaders,
    required super.expectedQueryParameters,
    required this.existingResourceResponse,
    required this.responseValues,
    required this.additionalContext,
  });
}

void apiTest<T>({
  required Future<T> Function(TestTrelloClient) apiCall,
  required List<ExpectedRequestWithResponseTests<T>> expectedRequests,
  bool testNotFound = true,
  bool testServerError = true,
}) {
  group('exists', () {
    //given
    var client = TestTrelloClient(
        responses:
            expectedRequests.map((e) => e.existingResourceResponse).toList());
    late final Future<T> response;

    //when
    setUpAll(() => response = apiCall(client));

    //then
    test('expected ${expectedRequests.length} requests',
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
        test('path', () => expect(request.path, expectedRequest.expectedPath));
        test(
            'query parameters',
            () => expect(request.queryParameters,
                expectedRequest.expectedQueryParameters));
        test('headers',
            () => expect(request.headers, expectedRequest.expectedHeaders));
      });
      group('response $count', () {
        for (var element in expectedRequest.responseValues) {
          test('property ${element.name}', () {
            verify<T>(response,
                (resource) => expect(element.get(resource), element.expected));
          });
        }
      });
    }
  });
  if (testNotFound) {
    group('not found', () {
      //given
      var missingResponse = createResponse(statusCode: 404, body: {});
      var client = TestTrelloClient(responses: [missingResponse]);
      late final Either<dynamic, T> response;

      //when
      setUpAll(() async => response = await apiCall(client)
          .then((result) => right(result))
          .onError((error, stackTrace) => left(error)));

      //then
      var count = 0;
      for (var expectedRequest in expectedRequests) {
        count++;
        group('request $count', () {
          var myCount = count;
          late RequestOptions request;
          setUp(() {
            if (client.fetchHistory.length >= count) {
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
        });
        group('response $count', () {
          test(
              'status code',
              () async => response.fold(
                    (l) => expect(
                        l.toString(),
                        ResourceNotFoundFailure(
                                resource: expectedRequest.expectedPath)
                            .withContext(expectedRequest.additionalContext)
                            .toString()),
                    (r) => fail('should have failed'),
                  ));
        });
      }
    });
  }
  if (testServerError) {
    group('server error', () {
      //given
      var missingResponse = createResponse(statusCode: 500, body: {});
      var client = TestTrelloClient(responses: [missingResponse]);
      late final Either<dynamic, T> response;

      //when
      setUpAll(() async => response = await apiCall(client)
          .then((result) => right(result))
          .onError((error, stackTrace) => left(error)));

      //then
      var count = 0;
      for (var expectedRequest in expectedRequests) {
        count++;
        group('request $count', () {
          var myCount = count;
          late RequestOptions request;
          setUp(() {
            if (client.fetchHistory.length >= count) {
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
        });
        group('response $count', () {
          test(
              'status code',
              () async => response.fold(
                    (l) => expect(
                        l.toString(),
                        HttpClientFailure(
                                message:
                                    '${expectedRequest.expectedMethod} ${expectedRequest.expectedPath}')
                            .withContext(expectedRequest.additionalContext)
                            .toString()),
                    (r) => fail('should have failed'),
                  ));
        });
      }
    });
  }
}
