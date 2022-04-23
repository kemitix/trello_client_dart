abstract class Failure {
  Failure({required String message}) {
    _message = message;
  }

  late final String _message;

  String get message => _message;

  @override
  String toString() {
    return 'Failure: $_message';
  }
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

class NotImplementedFailure extends Failure {
  NotImplementedFailure({required String function})
      : super(message: 'Function not implmented: $function');
}
