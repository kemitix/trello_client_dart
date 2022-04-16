import 'package:dio/dio.dart';

abstract class HttpResponse<T> {
  T? get data;
}

abstract class HttpClient {
  void close();

  Future<HttpResponse<T>> get<T>(String path,
      {Map<String, String>? queryParameters});
}

class DioHttpClient extends HttpClient {
  late final Dio _dio;
  DioHttpClient(
      {required String baseUrl, required Map<String, String> queryParameters}) {
    _dio = Dio(BaseOptions(baseUrl: baseUrl, queryParameters: queryParameters));
  }

  @override
  void close() => _dio.close();

  @override
  Future<HttpResponse<T>> get<T>(String path,
          {Map<String, String>? queryParameters}) async =>
      DioHttpResponse(
          await _dio.get<T>(path, queryParameters: queryParameters));
}

class DioHttpResponse<T> extends HttpResponse<T> {
  final Response<T> _response;
  DioHttpResponse(this._response);

  @override
  T? get data => _response.data;
}
