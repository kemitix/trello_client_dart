import 'dart:async' show Future, FutureOr;

import 'package:dio/dio.dart'
    show Dio, DioError, Options, Response, ResponseType;
import 'package:trello_sdk/external/files.dart' show defaultFileWriter;

import 'errors.dart' show HttpClientFailure, ResourceNotFoundFailure;
import 'file_name.dart' show FileName;
import 'query_options.dart' show QueryOptions;

abstract class HttpResponse<T> {
  T? get data;
}

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

class DioHttpResponse<T> extends HttpResponse<T> {
  final Response<T> _response;

  DioHttpResponse(this._response);

  @override
  T? get data => _response.data;
}
