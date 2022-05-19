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

  TaskEither<Failure, HttpResponse<T>> get<T>(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  });

  TaskEither<Failure, void> download(
    String path,
    FileName fileName, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    void Function(int, int)? onReceiveProgress,
  });

  TaskEither<Failure, HttpResponse<T>> put<T>(
    String path, {
    data,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  });

  TaskEither<Failure, HttpResponse<T>> post<T>(
    String path, {
    data,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  });

  TaskEither<Failure, HttpResponse<T>> delete<T>(
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
  TaskEither<Failure, HttpResponse<T>> get<T>(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) =>
      TaskEither.attempt(() => _dio.get<T>(path,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
          ))).bimap(
        (l) {
          if (l.runtimeType == DioError &&
              (l as DioError).response != null &&
              l.response!.statusCode == 404) {
            return ResourceNotFoundFailure(resource: path);
          }
          return HttpClientFailure(message: 'GET $path');
        },
        (r) => DioHttpResponse(r),
      );

  @override
  TaskEither<Failure, HttpResponse<T>> put<T>(
    String path, {
    data,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) =>
      TaskEither.attempt(() => _dio.put<T>(path,
          data: data,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
          ))).bimap(
        (l) {
          if (l.runtimeType == DioError &&
              (l as DioError).response != null &&
              l.response!.statusCode == 404) {
            return ResourceNotFoundFailure(resource: path);
          }
          return HttpClientFailure(message: 'PUT $path');
        },
        (r) => DioHttpResponse(r),
      );

  @override
  TaskEither<Failure, HttpResponse<T>> post<T>(
    String path, {
    data,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) =>
      TaskEither.attempt(() => _dio.post<T>(path,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: headers))).bimap(
        (l) {
          if (l.runtimeType == DioError &&
              (l as DioError).response != null &&
              l.response!.statusCode == 404) {
            return ResourceNotFoundFailure(resource: path);
          }
          return HttpClientFailure(message: 'POST $path');
        },
        (r) => DioHttpResponse(r),
      );

  @override
  TaskEither<Failure, HttpResponse<T>> delete<T>(
    String path, {
    data,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) =>
      TaskEither.attempt(() => _dio.delete<T>(path,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: headers))).bimap((l) {
        if (l.runtimeType == DioError &&
            (l as DioError).response != null &&
            l.response!.statusCode == 404) {
          return ResourceNotFoundFailure(resource: path);
        }
        return HttpClientFailure(message: 'DELETE $path');
      }, (r) => DioHttpResponse(r));

  @override
  TaskEither<Failure, FutureOr<void>> download(
    String path,
    FileName fileName, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    void Function(int, int)? onReceiveProgress,
  }) =>
      TaskEither.attempt(() => _dioDownloader.get(
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
          )).bimap(
        (l) {
          if (l.runtimeType == DioError &&
              (l as DioError).response != null &&
              l.response!.statusCode == 404) {
            return ResourceNotFoundFailure(resource: path);
          }
          return HttpClientFailure(message: '(download) GET $path');
        },
        (r) => _fileWriter(fileName, r.data),
      );
}

class DioHttpResponse<T> extends HttpResponse<T> {
  final Response<T> _response;

  DioHttpResponse(this._response);

  @override
  T? get data => _response.data;
}
