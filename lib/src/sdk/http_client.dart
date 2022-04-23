import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../trello_sdk.dart';

abstract class HttpResponse<T> {
  T? get data;
}

abstract class HttpClient {
  void close();

  Future<Either<Failure, HttpResponse<T>>> get<T>(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  });

  Future<Either<Failure, void>> download(
    String path,
    FileName fileName, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    void Function(int, int)? onReceiveProgress,
  });

  Future<Either<Failure, HttpResponse<T>>> put<T>(
    String path, {
    data,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  });
}

class DioHttpClient extends HttpClient {
  late final Dio _dio;
  late final Dio _dioDownloader;
  DioHttpClient(
      {required String baseUrl, required Map<String, String> queryParameters}) {
    _dio = Dio(BaseOptions(baseUrl: baseUrl, queryParameters: queryParameters));
    //_dio.interceptors.add(CurlLoggerDioInterceptor());
    _dioDownloader = Dio(BaseOptions(queryParameters: queryParameters));
    //_dioDownloader.interceptors.add(CurlLoggerDioInterceptor());
  }

  @override
  void close() {
    _dio.close();
    _dioDownloader.close();
  }

  @override
  Future<Either<Failure, HttpResponse<T>>> get<T>(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      var response = await _dio.get<T>(path,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
          ));
      var dioResponse = DioHttpResponse(response);
      return Right(dioResponse);
    } on DioError catch (e) {
      return Left(HttpClientFailure(message: 'GET $path - ${e.message}'));
    }
  }

  @override
  Future<Either<Failure, HttpResponse<T>>> put<T>(
    String path, {
    data,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      var response = await _dio.put<T>(path,
          data: data,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
          ));
      var dioResponse = DioHttpResponse(response);
      return Right(dioResponse);
    } on DioError catch (e) {
      return Left(HttpClientFailure(message: 'PUT $path - ${e.message}'));
    }
  }

  @override
  Future<Either<Failure, void>> download(
    String path,
    FileName fileName, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      var response = await _dioDownloader.get(
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
      );
      File file = File(fileName.value);
      var raf = file.openSync(mode: FileMode.write);
      //   // response.data is List<int> type
      raf.writeFromSync(response.data);
      return Right(await raf.close());
    } on DioError catch (e) {
      return Left(
          HttpClientFailure(message: '(download) GET $path - ${e.message}'));
    }
  }
}

class CurlLoggerDioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
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
