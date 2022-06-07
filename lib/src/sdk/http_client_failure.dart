import 'failure.dart';

class HttpClientFailure extends Failure {
  HttpClientFailure({
    required String message,
    Map<String, String>? context,
  }) : super(message: message, context: context);
}
