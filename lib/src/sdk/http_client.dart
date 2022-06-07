import 'dart:async' show Future;

import 'package:dio/dio.dart' show Response;

import 'file_name.dart';
import 'http_response.dart';
import 'query_options.dart';

abstract class HttpClient {
  void close();

  Future<HttpResponse<T>> get<T>(QueryOptions queryOptions);

  Future<void> download(
    QueryOptions queryOptions,
    FileName fileName, {
    void Function(int, int)? onReceiveProgress,
  });

  Future<HttpResponse<T>> put<T>(
    QueryOptions queryOptions, {
    data,
  });

  Future<HttpResponse<T>> post<T>(
    QueryOptions queryOptions, {
    data,
  });

  Future<HttpResponse<T>> delete<T>(
    QueryOptions queryOptions, {
    data,
  });
}

class DioHttpResponse<T> extends HttpResponse<T> {
  final Response<T> _response;

  DioHttpResponse(this._response);

  @override
  T? get data => _response.data;
}
