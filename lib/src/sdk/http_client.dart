import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../trello_sdk.dart';

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
    //_dio.interceptors.add(CurlLoggerDioInterceptor());
    _dioDownloader = dioFactory('', queryParameters);
    //_dioDownloader.interceptors.add(CurlLoggerDioInterceptor());
    _fileWriter = fileWriter ?? defaultFileWriter;
  }

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
      TaskEither.fromTask(Task(() => _dio.get<T>(path,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
          )))).bimap(
        (l) => HttpClientFailure(message: 'GET $path - ${l.message}'),
        (r) => DioHttpResponse(r),
      );

  @override
  TaskEither<Failure, HttpResponse<T>> put<T>(
    String path, {
    data,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) =>
      TaskEither.fromTask(Task(() => _dio.put<T>(path,
          data: data,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
          )))).bimap(
        (l) => HttpClientFailure(message: 'PUT $path - ${l.message}'),
        (r) => DioHttpResponse(r),
      );

  @override
  TaskEither<Failure, HttpResponse<T>> post<T>(
    String path, {
    data,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) =>
      TaskEither.fromTask(Task(() => _dio.post<T>(path,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: headers)))).bimap(
        (l) => HttpClientFailure(message: 'POST $path - ${l.message}'),
        (r) => DioHttpResponse(r),
      );

  @override
  TaskEither<Failure, FutureOr<void>> download(
    String path,
    FileName fileName, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    void Function(int, int)? onReceiveProgress,
  }) =>
      TaskEither.fromTask(Task(() => _dioDownloader.get(
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
          ))).bimap(
        (l) =>
            HttpClientFailure(message: '(download) GET $path - ${l.message}'),
        (r) {
          return _fileWriter(fileName, r.data);
        },
      );

  Future<void> defaultFileWriter(FileName fileName, dynamic data) {
    var f = File(fileName.value).openSync(mode: FileMode.write);
    f.writeFromSync(data);
    return f.close();
  }
}

class CurlLoggerDioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('query parameters: ${options.queryParameters}');
    print(dio2curl(options));
    handler.next(options);
  }

  String dio2curl<T>(RequestOptions requestOptions) {
    var curl = '';
    // Add PATH + REQUEST_METHOD
    curl += "curl --request ${requestOptions.method} ";
    // Add query parameters
    var params = <String>[];
    requestOptions.queryParameters.forEach((key, value) {
      params.add('$key=$value');
    });
    var queryParameters = '';
    if (params.isNotEmpty) queryParameters += '?' + params.join('&');
    // assemble url
    curl += '"${requestOptions.baseUrl}${requestOptions.path}$queryParameters"';
    // Include headers
    for (var key in requestOptions.headers.keys) {
      curl += ' -H \'$key: ${requestOptions.headers[key]}\'';
    }
    // Include data if there is data
    if (requestOptions.data != null) {
      curl += ' --data-binary \'${requestOptions.data}\'';
    }
    curl += ' --insecure'; //bypass https verification
    return curl;
  }
}

class DioHttpResponse<T> extends HttpResponse<T> {
  final Response<T> _response;
  DioHttpResponse(this._response);

  @override
  T? get data => _response.data;
}
