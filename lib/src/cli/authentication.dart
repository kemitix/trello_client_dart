// authentication

import '../../trello_cli.dart';

typedef Error = String;
typedef ErrorList = List<Error>;

Reader<Environment, Either<Error, String>> _getEnv(String name) =>
    Reader((env) => right<Error, String>(name)
        .map((r) => env[r])
        .where((r) => r != null, () => 'Environment not set $name')
        .map((r) => r!));

Function3<Either<Error, MemberId>, Either<Error, String>, Either<Error, String>,
        Either<Error, TrelloAuthentication>> _authenticator =
    Either.lift3<Error, MemberId, String, String, TrelloAuthentication>(
        (memberId, key, secret) =>
            TrelloAuthentication.of(memberId, key, secret));

Reader<Environment, Either<Error, TrelloAuthentication>> authentication() =>
    Reader((env) => _authenticator(
        _getEnv('TRELLO_USERNAME').run(env).map((id) => MemberId(id)),
        _getEnv('TRELLO_KEY').run(env),
        _getEnv('TRELLO_SECRET').run(env)));
