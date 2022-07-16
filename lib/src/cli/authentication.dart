import 'package:trello_client/trello_sdk.dart'
    show Either, Left, MemberId, Right, TrelloAuthentication;
import 'package:verify/verify.dart'
    show ValidationError, Validator, ValidatorUtils, Verify;

import 'runner.dart';

typedef Errors = List<dynamic>;

Either<Errors, TrelloAuthentication> authentication(Environment e) {
  Validator<Environment> environmentIsSet(String key) => (Environment e) =>
      e.keys.contains(key) ? Right(e) : Left([EnvironmentError(key)]);

  Validator<Environment> validator = Verify.all<Environment>([
    'USERNAME',
    'KEY',
    'SECRET'
  ].map((v) => 'TRELLO_$v').map((key) => environmentIsSet(key)).toList());

  Either<List<ValidationError>, Environment> verified =
      validator.verify<ValidationError>(e);
  return verified
      .map((e) => TrelloAuthentication.of(
            MemberId(e['TRELLO_USERNAME']!),
            e['TRELLO_KEY']!,
            e['TRELLO_SECRET']!,
          ))
      .leftMap((l) => l.map((ve) => ve.errorDescription).toList());
}

class EnvironmentError extends ValidationError {
  @override
  String get errorDescription => 'Environment not set $_key';

  EnvironmentError(this._key);

  final String _key;
}
