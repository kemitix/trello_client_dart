import 'package:dio/dio.dart';

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
}

class DioHttpClient extends HttpClient {
  late final Dio _dio;
  DioHttpClient(
      {required String baseUrl, required Map<String, String> queryParameters}) {
    _dio = Dio(BaseOptions(baseUrl: baseUrl, queryParameters: queryParameters));
    //_dio.interceptors.add(CurlLoggerDioInterceptor());
  }

  @override
  void close() => _dio.close();

  @override
  Future<HttpResponse<T>> get<T>(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async =>
      DioHttpResponse(await _dio.get<T>(path,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
          )));
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
