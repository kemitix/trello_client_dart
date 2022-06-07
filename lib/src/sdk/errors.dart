import 'failure.dart';

class UsageFailure extends Failure {
  UsageFailure({
    required String usage,
    Map<String, String>? context,
  }) : super(message: usage, context: context);
}

class AlreadyAppliedFailure extends Failure {
  AlreadyAppliedFailure({
    required String action,
    Map<String, String>? context,
  }) : super(
            message: "Can't $action as it is already applied",
            context: context);
}
