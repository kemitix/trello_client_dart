import 'package:dio/dio.dart';

import 'http_response.dart';

class DioHttpResponse<T> extends HttpResponse<T> {
  final Response<T> _response;

  DioHttpResponse(this._response);

  @override
  T? get data => _response.data;
}
