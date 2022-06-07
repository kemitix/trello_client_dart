import 'failure.dart' show Failure;

class NoUpdatesFailure extends Failure {
  NoUpdatesFailure() : super(message: 'No updates');
}
