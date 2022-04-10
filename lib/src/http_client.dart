import 'package:dio/dio.dart';

abstract class HttpClient {
  void close();

  get(String path, {Map<String, String>? queryParameters});
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
  get(String path, {Map<String, String>? queryParameters}) =>
      _dio.get(path, queryParameters: queryParameters);
}
