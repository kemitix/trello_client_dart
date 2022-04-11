import 'dart:io';

import 'package:console/console.dart';
import 'package:trello_client/src/boards/boards.dart';
import 'package:trello_client/src/cards/cards.dart';
import 'package:trello_client/src/fp/fp.dart';
import 'package:trello_client/src/lists/lists.dart';
import 'package:trello_client/trello_client.dart';

typedef Error = String;
typedef ErrorList = List<Error>;

Future<void> main(List<String> arguments) async =>
    await parseArgs(arguments).map(trelloClient).fold<Future<void>>(
          onError: (errors) => reportErrors(errors),
          onSuccess: (client) => runApp(client),
        );

const String choiceQuit = '<< Quit';
const String choiceBack = '< Back';
const String separator = '--------------------------';

Future<void> runApp(TrelloClient client) async {
  List<String> menu = [choiceQuit, 'Open Board'];
  while (true) {
    print(separator);
    String choice = Chooser<String>(menu, message: "Select: ").chooseSync();
    switch (choice) {
      case choiceQuit:
        client.close();
        exit(0);
      case 'Open Board':
        await selectBoard(client);
    }
  }
}

Future<void> selectBoard(TrelloClient client) async {
  List<Board> boards = await client.members.boards
      .get(client.username, fields: [BoardFields.id, BoardFields.name]);
  List<String> menu = boards.map((board) => board.name).toList();
  menu.insert(0, choiceBack);
  while (true) {
    print(separator);
    String choice =
        Chooser<String>(menu, message: "Select Board: ").chooseSync();
    switch (choice) {
      case choiceBack:
        return;
      default:
        String boardId = boards
            .where((board) => board.name == choice)
            .map((board) => board.id)
            .first;
        print({boardId});
        await selectList(boardId, choice, client);
    }
  }
}

Future<void> selectList(
    String boardId, String boardName, TrelloClient client) async {
  List<TrelloList> lists = await client.boards.lists
      .get(boardId, fields: [ListFields.id, ListFields.name]);
  List<String> menu = lists.map((list) => list.name).toList();
  menu.insert(0, choiceBack);
  while (true) {
    print(separator);
    String choice =
        Chooser<String>(menu, message: "Select List: ").chooseSync();
    switch (choice) {
      case choiceBack:
        return;
      default:
        String listId = lists
            .where((list) => list.name == choice)
            .map((list) => list.id)
            .first;
        print({listId});
        await selectCard(listId, choice, boardName, client);
    }
  }
}

Future<void> selectCard(String listId, String listName, String boardName,
    TrelloClient client) async {
  List<Card> cards = await client.lists.cards
      .get(listId, fields: [CardFields.id, CardFields.name]);
  List<String> menu = cards.map((card) => card.name).toList();
  menu.insert(0, choiceBack);
  while (true) {
    print(separator);
    String choice =
        Chooser<String>(menu, message: "Select Card: ").chooseSync();
    switch (choice) {
      case choiceBack:
        return;
      default:
        String cardId = cards
            .where((card) => card.name == choice)
            .map((card) => card.id)
            .first;
        print({cardId});
        await showCard(cardId, choice, listName, boardName, client);
    }
  }
}

  Card? card = await client.cards.get(cardId);
Future<void> showCard(String cardId, String cardName, String listName,
    String boardName, TrelloClient client) async {
  if (card != null) {
    print('Card: ${card.id} - ${card.name}');
  } else {
    print('Card not found');
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
