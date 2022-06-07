import 'failure.dart';

class AlreadyAppliedFailure extends Failure {
  AlreadyAppliedFailure({
    required String action,
    Map<String, String>? context,
  }) : super(
            message: "Can't $action as it is already applied",
            context: context);
}
