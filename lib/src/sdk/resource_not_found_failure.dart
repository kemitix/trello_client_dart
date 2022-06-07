import 'failure.dart';

class ResourceNotFoundFailure extends Failure {
  ResourceNotFoundFailure({
    required String resource,
    Map<String, String>? context,
  }) : super(message: 'Resource not found: $resource', context: context);
}
