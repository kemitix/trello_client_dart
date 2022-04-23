abstract class Failure {
  Failure({
    required String message,
    Map<String, String>? context,
  }) {
    _message = message;
    _context = context ?? {};
  }

  late final String _message;
  late Map<String, String> _context;

  String get message => _message;

  @override
  String toString() {
    return 'Failure: $_message - $_context';
  }

  Failure withContext(Map<String, String> additionalContext) {
    _context.addAll(additionalContext);
    return this;
  }
}

class HttpClientFailure extends Failure {
  HttpClientFailure({
    required String message,
    Map<String, String>? context,
  }) : super(message: message, context: context);
}

class ResourceNotFoundFailure extends Failure {
  ResourceNotFoundFailure({
    required String resource,
    Map<String, String>? context,
  }) : super(message: 'Resource not found: $resource}', context: context);
}

class UsageFailure extends Failure {
  UsageFailure({
    required String usage,
    Map<String, String>? context,
  }) : super(message: usage, context: context);
}

class NotImplementedFailure extends Failure {
  NotImplementedFailure({
    required String function,
    Map<String, String>? context,
  }) : super(message: 'Function not implemented: $function', context: context);
}
