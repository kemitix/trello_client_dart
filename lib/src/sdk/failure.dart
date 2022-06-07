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

  @override
  String toString() =>
      'Failure: $_message${_context.isEmpty ? '' : ' - $_context'}';

  Failure withContext(Map<String, String> additionalContext) {
    _context.addAll(additionalContext);
    return this;
  }
}
