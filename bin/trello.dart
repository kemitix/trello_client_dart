import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dartz/dartz.dart';
import 'package:trello_sdk/trello_cli.dart';

typedef Error = String;
typedef ErrorList = List<Error>;

Future<void> main(List<String> arguments) =>
    authentication().map(trelloClient).fold<Future<void>>(
          (errors) => reportErrors(errors),
          (client) => runApp(client, arguments),
        );

Future<void> runApp(TrelloClient client, List<String> arguments) =>
    _runner(client)
        .run(arguments)
        .catchError(_handleError)
        .whenComplete(() => client.close());

void _handleError(error) {
  if (error is! UsageException) throw error;
  print(error);
}

CommandRunner _runner(TrelloClient client) {
  var runner = CommandRunner('trello', "A CLI for Trello");
  [
    MemberModule(client),
    BoardModule(client),
    ListModule(client),
    CardModule(client),
  ].forEach(runner.addCommand);
  return runner;
}

Future<void> reportErrors(ErrorList errors) async => errors.forEach(print);

Either<ErrorList, TrelloAuthentication> authentication() {
  var userEnv = 'TRELLO_USERNAME';
  var keyEnv = 'TRELLO_KEY';
  var tokenEnv = 'TRELLO_SECRET';
  var e = <String>[];
  void testEnvironment(String key) {
    if (!Platform.environment.keys.contains(key)) {
      e.add('Environment no set $key');
    }
  }

  testEnvironment(userEnv);
  testEnvironment(keyEnv);
  testEnvironment(tokenEnv);
  if (e.isNotEmpty) return Left(e);

  var memberId = MemberId(Platform.environment[userEnv]!);
  var key = Platform.environment[keyEnv]!;
  var token = Platform.environment[tokenEnv]!;
  return Right(TrelloAuthentication.of(memberId, key, token));
}

TrelloClient trelloClient(TrelloAuthentication authentication) =>
    TrelloClient(authentication);
