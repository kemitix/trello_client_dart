abstract class Failure {
  Failure({required String message}) {
    _message = message;
  }

  late final String _message;

  String get message => _message;
}

class HttpClientFailure extends Failure {
  HttpClientFailure({required String message}) : super(message: message);
}

class ResourceNotFoundFailure extends Failure {
  ResourceNotFoundFailure({required String resource})
      : super(message: 'Resource not found: $resource}');
}

class UsageFailure extends Failure {
  UsageFailure({required String usage}) : super(message: usage);
}
