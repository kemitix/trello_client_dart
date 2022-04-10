import 'dart:io';

import 'package:console/console.dart';
import 'package:trello_client/src/fp/fp.dart';
import 'package:trello_client/src/models/models.dart';
import 'package:trello_client/trello_client.dart';

typedef Error = String;
typedef ErrorList = List<Error>;

Future<void> main(List<String> arguments) async =>
    await parseArgs(arguments).map(trelloClient).fold<Future<void>>(
          onError: (errors) => reportErrors(errors),
          onSuccess: (client) => runApp(client),
        );

const String choiceQuit = '< Quit';
const String choiceSeparator = '--------------------------';

Future<void> runApp(TrelloClient client) async {
  List<String> menu = [choiceQuit, 'Open Board'];
  while (true) {
    print(choiceSeparator);
    String choice = Chooser<String>(menu, message: "Select: ").chooseSync();
    switch (choice) {
      case choiceQuit:
        client.close();
        exit(0);
      case 'Open Board':
        await openBoard(client);
        break;
    }
  }
}

Future<void> openBoard(TrelloClient client) async {
  List<Board> boards = await client.members
      .getMemberBoards(fields: [BoardFields.id, BoardFields.name]);
  List<String> menu = boards.map((board) => board.name).toList();
  menu.insert(0, choiceQuit);
  while (true) {
    print(choiceSeparator);
    String choice =
        Chooser<String>(menu, message: "Select Board: ").chooseSync();
    switch (choice) {
      case choiceQuit:
        return;
      default:
        String boardId = boards
            .where((board) => board.name == choice)
            .map((board) => board.id)
            .first;
        print({boardId});
    }
  }
}

Future<void> reportErrors(ErrorList errors) async => errors.forEach(print);

Either<ErrorList, TrelloAuthentication> parseArgs(List<String> arguments) {
  if (arguments.isEmpty) {
    return Left.of(['Trello Username, API key and token not given']);
  }
  final String username = arguments[0];
  if (arguments.length < 2) {
    return Left.of(['Trello API key and token not given']);
  }
  final String key = arguments[1];
  if (arguments.length < 3) {
    return Left.of(['Trello API token not given']);
  }
  final String secret = arguments[2];
  if (arguments.length > 3) {
    return Left.of(['Too many arguments']);
  }
  return Right.of(TrelloAuthentication.of(username, key, secret));
}

TrelloClient trelloClient(TrelloAuthentication authentication) =>
    TrelloClient(authentication);
