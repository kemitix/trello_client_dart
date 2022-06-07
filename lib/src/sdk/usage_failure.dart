import 'failure.dart';

class UsageFailure extends Failure {
  UsageFailure({
    required String usage,
    Map<String, String>? context,
  }) : super(message: usage, context: context);
}
