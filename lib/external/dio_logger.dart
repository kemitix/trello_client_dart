import 'package:dio/dio.dart'
    show Interceptor, RequestInterceptorHandler, RequestOptions;

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
