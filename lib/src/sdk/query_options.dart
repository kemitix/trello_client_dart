class QueryOptions {
  final String path;
  final Map<String, String> queryParameters;
  final Map<String, String> headers;

  QueryOptions(this.path, this.queryParameters, this.headers);
}
