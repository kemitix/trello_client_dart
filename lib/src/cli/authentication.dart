// authentication

import 'package:equatable/equatable.dart';
import 'package:trello_sdk/src/cli/runner.dart';
import 'package:verify/verify.dart';

import '../../trello_cli.dart';

typedef Errors = List<dynamic>;

Either<Errors, TrelloAuthentication> authentication(Environment e) {
  Function1<String, Validator<Environment>> environmentIsSet = (String key) =>
      (Environment e) =>
          e.keys.contains(key) ? Right(e) : Left([EnvironmentError(key)]);

  Validator<Environment> validator = Verify.all<Environment>([
    'USERNAME',
    'KEY',
    'SECRET'
  ].map((v) => 'TRELLO_$v').map((key) => environmentIsSet(key)).toList());

  Either<List<ValidationError>, Environment> verified =
      validator.verify<ValidationError>(e);
  // FIXME this appears to be a bug in the 'verify' implementation that is losing all the errors
  // all we get is an empty list of errors.
  return verified
      .map((e) => TrelloAuthentication.of(
            MemberId(e['TRELLO_USERNAME']!),
            e['TRELLO_KEY']!,
            e['TRELLO_SECRET']!,
          ))
      .leftMap((l) => l.map((ve) => ve.errorDescription).toList());
}

class EnvironmentError extends ValidationError with EquatableMixin {
  @override
  String get errorDescription => 'Environment not set $_key';

  EnvironmentError(this._key);

  final String _key;

  @override
  List<Object?> get props => [_key];
}
