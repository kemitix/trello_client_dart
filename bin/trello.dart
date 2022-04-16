import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:trello_sdk/trello_cli.dart';

typedef Error = String;
typedef ErrorList = List<Error>;

Future<void> main(List<String> arguments) async =>
    await authentication().map(trelloClient).fold<Future<void>>(
          onError: (errors) => reportErrors(errors),
          onSuccess: (client) => runApp(client, arguments),
        );

Future<void> runApp(TrelloClient client, List<String> arguments) async {
  var runner = CommandRunner('trello', "A CLI for Trello");
  runner.addCommand(MemberCommand(client));
  await runner.run(arguments).catchError((error) {
    client.close();
    if (error is! UsageException) {
      throw error;
    }
    print(error);
    exit(1);
  });
  client.close();
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
  if (e.isNotEmpty) return Left.of(e);

  var memberId = MemberId(Platform.environment[userEnv]!);
  var key = Platform.environment[keyEnv]!;
  var token = Platform.environment[tokenEnv]!;
  return Right.of(TrelloAuthentication.of(memberId, key, token));
}

TrelloClient trelloClient(TrelloAuthentication authentication) =>
    TrelloClient(authentication);
