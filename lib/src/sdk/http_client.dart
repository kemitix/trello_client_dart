import 'dart:async';

import 'package:dio/dio.dart';

import '../../trello_sdk.dart';
import 'external/dio_logger.dart';
import 'external/files.dart';

abstract class HttpResponse<T> {
  T? get data;
}

abstract class HttpClient {
  void close();

  Future<HttpResponse<T>> get<T>(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  });

  Future<void> download(
    String path,
    FileName fileName, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    void Function(int, int)? onReceiveProgress,
  });

  Future<HttpResponse<T>> put<T>(
    String path, {
    data,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  });

  Future<HttpResponse<T>> post<T>(
    String path, {
    data,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  });

  Future<HttpResponse<T>> delete<T>(
    String path, {
    data,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
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
    //_dio.interceptors.add(curlLogger());
    _dioDownloader = dioFactory('', queryParameters);
    //_dioDownloader.interceptors.add(CurlLoggerDioInterceptor());
    _fileWriter = fileWriter ?? defaultFileWriter;
  }

  Interceptor curlLogger() => CurlLoggerDioInterceptor();

  @override
  void close() {
    _dio.close();
    _dioDownloader.close();
  }

  @override
  Future<HttpResponse<T>> get<T>(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) =>
      _dio
          .get<T>(path,
              queryParameters: queryParameters,
              options: Options(
                headers: headers,
              ))
          .onError((error, stackTrace) {
        if (error.runtimeType == DioError &&
            (error as DioError).response != null &&
            error.response!.statusCode == 404) {
          return Future.error(ResourceNotFoundFailure(resource: path));
        }
        return Future.error(HttpClientFailure(message: 'GET $path'));
      }).then((r) => DioHttpResponse(r));

  @override
  Future<HttpResponse<T>> put<T>(
    String path, {
    data,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) =>
      _dio
          .put<T>(path,
              data: data,
              queryParameters: queryParameters,
              options: Options(
                headers: headers,
              ))
          .onError((error, stackTrace) {
        if (error.runtimeType == DioError &&
            (error as DioError).response != null &&
            error.response!.statusCode == 404) {
          return Future.error(ResourceNotFoundFailure(resource: path));
        }
        return Future.error(HttpClientFailure(message: 'PUT $path'));
      }).then(
        (r) => DioHttpResponse(r),
      );

  @override
  Future<HttpResponse<T>> post<T>(
    String path, {
    data,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) =>
      _dio
          .post<T>(path,
              data: data,
              queryParameters: queryParameters,
              options: Options(headers: headers))
          .onError((error, stackTrace) {
        if (error.runtimeType == DioError &&
            (error as DioError).response != null &&
            error.response!.statusCode == 404) {
          return Future.error(ResourceNotFoundFailure(resource: path));
        }
        return Future.error(HttpClientFailure(message: 'POST $path'));
      }).then(
        (r) => DioHttpResponse(r),
      );

  @override
  Future<HttpResponse<T>> delete<T>(
    String path, {
    data,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) =>
      _dio
          .delete<T>(path,
              data: data,
              queryParameters: queryParameters,
              options: Options(headers: headers))
          .onError((error, stackTrace) {
        if (error.runtimeType == DioError &&
            (error as DioError).response != null &&
            error.response!.statusCode == 404) {
          return Future.error(ResourceNotFoundFailure(resource: path));
        }
        return Future.error(HttpClientFailure(message: 'DELETE $path'));
      }).then((r) => DioHttpResponse(r));

  @override
  Future<void> download(
    String path,
    FileName fileName, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    void Function(int, int)? onReceiveProgress,
  }) =>
      _dioDownloader
          .get(
        path, onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 500;
          },
          headers: headers,
        ),
      )
          .onError((error, stackTrace) {
        if (error.runtimeType == DioError &&
            (error as DioError).response != null &&
            error.response!.statusCode == 404) {
          return Future.error(ResourceNotFoundFailure(resource: path));
        }
        return Future.error(HttpClientFailure(message: '(download) GET $path'));
      }).then(
        (r) => _fileWriter(fileName, r.data),
      );
}

class DioHttpResponse<T> extends HttpResponse<T> {
  final Response<T> _response;

  DioHttpResponse(this._response);

  @override
  T? get data => _response.data;
}
