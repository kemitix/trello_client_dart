import 'dart:async';

import 'package:dio/dio.dart';
import 'package:trello_sdk/external/files.dart' show defaultFileWriter;

import 'dio_http_response.dart';
import 'file_name.dart';
import 'http_client.dart';
import 'http_client_failure.dart';
import 'http_response.dart';
import 'query_options.dart';
import 'resource_not_found_failure.dart';

class DioHttpClient extends HttpClient {
  late final Dio _dio;
  late final Dio _dioDownloader;
  late Future<void> Function(FileName fileName, dynamic data) _fileWriter;

  DioHttpClient({
    required String baseUrl,
    required Map<String, String> queryParameters,
    required Dio Function(String, Map<String, String>) dioFactory,
    Future<void> Function(FileName fileName, dynamic data)? fileWriter,
  }) {
    _dio = dioFactory(baseUrl, queryParameters);
    _dioDownloader = dioFactory('', queryParameters);
    _fileWriter = fileWriter ?? defaultFileWriter;
  }

//  Interceptor curlLogger() => CurlLoggerDioInterceptor();

  @override
  void close() {
    _dio.close();
    _dioDownloader.close();
  }

  @override
  Future<HttpResponse<T>> get<T>(QueryOptions queryOptions) => _dio
      .get<T>(queryOptions.path,
          queryParameters: queryOptions.queryParameters,
          options: Options(
            headers: queryOptions.headers,
          ))
      .onError(errorHandler('GET', queryOptions))
      .then((r) => DioHttpResponse(r));

  @override
  Future<HttpResponse<T>> put<T>(
    QueryOptions queryOptions, {
    data,
  }) =>
      _dio
          .put<T>(queryOptions.path,
              data: data,
              queryParameters: queryOptions.queryParameters,
              options: Options(
                headers: queryOptions.headers,
              ))
          .onError(errorHandler('PUT', queryOptions))
          .then((r) => DioHttpResponse(r));

  @override
  Future<HttpResponse<T>> post<T>(
    QueryOptions queryOptions, {
    data,
  }) =>
      _dio
          .post<T>(queryOptions.path,
              data: data,
              queryParameters: queryOptions.queryParameters,
              options: Options(headers: queryOptions.headers))
          .onError(errorHandler('POST', queryOptions))
          .then((r) => DioHttpResponse(r));

  @override
  Future<HttpResponse<T>> delete<T>(
    QueryOptions queryOptions, {
    data,
  }) =>
      _dio
          .delete<T>(queryOptions.path,
              data: data,
              queryParameters: queryOptions.queryParameters,
              options: Options(headers: queryOptions.headers))
          .onError(errorHandler('DELETE', queryOptions))
          .then((r) => DioHttpResponse(r));

  @override
  Future<void> download(
    QueryOptions queryOptions,
    FileName fileName, {
    void Function(int, int)? onReceiveProgress,
  }) =>
      _dioDownloader
          .get(
            queryOptions.path,
            onReceiveProgress: onReceiveProgress,
            queryParameters: queryOptions.queryParameters,
            options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) => status != null && status < 500,
              headers: queryOptions.headers,
            ),
          )
          .onError(errorHandler('(download) GET', queryOptions))
          .then((r) => _fileWriter(fileName, r.data));

  FutureOr<Response<T>> Function(Object error, StackTrace stackTrace)
      errorHandler<T>(String method, QueryOptions queryOptions) =>
          (Object error, StackTrace stackTrace) {
            if (error.runtimeType == DioError &&
                (error as DioError).response != null &&
                error.response!.statusCode == 404) {
              return Future.error(
                  ResourceNotFoundFailure(resource: queryOptions.path));
            }
            return Future.error(
                HttpClientFailure(message: '$method ${queryOptions.path}'));
          };
}
