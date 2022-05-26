class QueryOptions {
  final String path;
  late final Map<String, String> queryParameters;
  late final Map<String, String> headers;

  QueryOptions({
    required this.path,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) {
    this.queryParameters = queryParameters ?? {};
    this.headers = headers ?? {};
  }
}
