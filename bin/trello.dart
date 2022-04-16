import 'dart:io';

import 'package:cli_dialog/cli_dialog.dart';
import 'package:trello_sdk/trello_sdk.dart';

typedef Error = String;
typedef ErrorList = List<Error>;

Future<void> main(List<String> arguments) async =>
    await authentication().map(trelloClient).fold<Future<void>>(
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
    String choice = listQuestion(menu, message: "Select: ");
    switch (choice) {
      case choiceQuit:
        client.close();
        exit(0);
      case 'Open Board':
        await selectBoard(client);
    }
  }
}

String listQuestion(List<String> menu, {required String message}) {
  return CLI_Dialog(listQuestions: [
    [
      {
        'question': message,
        'options': menu,
      },
      'question'
    ]
  ]).ask()['question'];
}

Future<void> selectBoard(TrelloClient client) async {
  List<Board> boards = await client
      .member(client.memberId)
      .getBoards(fields: [BoardFields.id, BoardFields.name]);
  List<String> menu = boards.map((board) => board.name).toList();
  menu.insert(0, choiceBack);
  while (true) {
    print(separator);
    String choice = listQuestion(menu, message: "Select Board: ");
    switch (choice) {
      case choiceBack:
        return;
      default:
        BoardId boardId = boards
            .where((board) => board.name == choice)
            .map((board) => board.id)
            .first;
        print({boardId});
        await selectList(boardId, choice, client);
    }
  }
}

Future<void> selectList(
    BoardId boardId, String boardName, TrelloClient client) async {
  List<TrelloList> lists = await client
      .board(boardId)
      .getLists(fields: [ListFields.id, ListFields.name]);
  List<String> menu = lists.map((list) => list.name).toList();
  menu.insert(0, choiceBack);
  while (true) {
    print(separator);
    String choice = listQuestion(menu, message: "Select List: ");
    switch (choice) {
      case choiceBack:
        return;
      default:
        ListId listId = lists
            .where((list) => list.name == choice)
            .map((list) => list.id)
            .first;
        print({listId});
        await selectCard(listId, choice, boardName, client);
    }
  }
}

Future<void> selectCard(ListId listId, String listName, String boardName,
    TrelloClient client) async {
  List<Card> cards = await client
      .list(listId)
      .getCards(fields: [CardFields.id, CardFields.name]);
  List<String> menu = cards.map((card) => card.name).toList();
  menu.insert(0, choiceBack);
  while (true) {
    print(separator);
    String choice = listQuestion(menu, message: "Select Card: ");
    switch (choice) {
      case choiceBack:
        return;
      default:
        CardId cardId = cards
            .where((card) => card.name == choice)
            .map((card) => card.id)
            .first;
        print({cardId});
        await showCard(cardId, choice, listName, boardName, client);
    }
  }
}

Future<void> showCard(CardId cardId, String cardName, String listName,
    String boardName, TrelloClient client) async {
  Card? card = await client.card(cardId).get();
  if (card != null) {
    print('Card: ${card.id} - ${card.name}');
  } else {
    print('Card not found');
  }
}

Future<void> reportErrors(ErrorList errors) async => errors.forEach(print);

Either<ErrorList, TrelloAuthentication> authentication() {
  var userEnv = 'TRELLO_USERNAME';
  var keyEnv = 'TRELLO_KEY';
  var tokenEnv = 'TRELLO_SECRET';
  var e = <String>[];
  void testEnvironment(String key) {
    if (!Platform.environment.keys.contains(key)) {
      e.add('Environment no set ${key}');
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
