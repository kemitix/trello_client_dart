import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:trello_sdk/src/sdk/client.dart';
import 'package:trello_sdk/src/sdk/fp/fp.dart';
import 'package:trello_sdk/src/sdk/http_client.dart';
import 'package:trello_sdk/src/sdk/sdk.dart';

class DioAdapterMock implements HttpClientAdapter {
  final List<Tuple3<RequestOptions, Stream<Uint8List>?, Future<dynamic>?>>
      _fetchHistory = [];
  final List<ResponseBody> _fetchResponses;
  int _nextResponseIndex = 0;

  DioAdapterMock(this._fetchResponses);

  @override
  void close({bool force = false}) {
    // TODO: implement close
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<dynamic>? cancelFuture,
  ) async {
    _fetchHistory.add(Tuple3(options, requestStream, cancelFuture));
    return _fetchResponses.length > _nextResponseIndex
        ? Future.value(_fetchResponses[_nextResponseIndex++])
        : throw StateError("No fetchResponse available to return");
  }

  List<Tuple3<RequestOptions, Stream<Uint8List>?, Future<dynamic>?>>
      get fetchHistory => _fetchHistory;
}

Dio mockDio(String baseUrl, Map<String, String> queryParameters,
    DioAdapterMock dioAdapterMock) {
  final Dio dio =
      Dio(BaseOptions(baseUrl: baseUrl, queryParameters: queryParameters));
  dio.httpClientAdapter = dioAdapterMock;
  return dio;
}

class TestTrelloClient {
  TestTrelloClient(
    this._client,
    this._dioAdapterMock,
    this._fakeFileWriter,
  );
  final TrelloClient _client;
  final DioAdapterMock _dioAdapterMock;
  final FakeFileWriter _fakeFileWriter;
  TrelloClient get trelloClient => _client;
  List<Tuple3<RequestOptions, Stream<Uint8List>?, Future<dynamic>?>>
      get fetchHistory => _dioAdapterMock.fetchHistory;
  List<Tuple2<FileName, dynamic>> get filesWritten =>
      _fakeFileWriter.filesWritten;
}

TestTrelloClient testTrelloClient({
  required String baseUrl,
  required Map<String, String> queryParameters,
  required TrelloAuthentication authentication,
  required List<ResponseBody> responses,
}) {
  var adapterMock = DioAdapterMock(responses);
  var fakeFileWriter = FakeFileWriter();
  var client = TrelloClient(
      DioHttpClient(
          baseUrl: baseUrl,
          queryParameters: queryParameters,
          dioFactory: (baseUrl, queryParameters) =>
              mockDio(baseUrl, queryParameters, adapterMock),
          fileWriter: fakeFileWriter.fileWriter),
      authentication);

  return TestTrelloClient(client, adapterMock, fakeFileWriter);
}

class FakeFileWriter {
  List<Tuple2<FileName, dynamic>> filesWritten = [];
  Future<void> Function(FileName, dynamic) _fileWriter() =>
      (fn, d) async => filesWritten.add(Tuple2(fn, d));
  Future<void> Function(FileName, dynamic) get fileWriter => _fileWriter();
}
