import 'dart:async';

import '../../../../trello_sdk.dart';
import 'board_module.dart';

class ListListsCommand extends BoardCommand {
  ListListsCommand(TrelloClient client)
      : super('list-lists', 'Get Lists on a Board', client);

  final List<ListFields> fields = [
    ListFields.id,
    ListFields.name,
    ListFields.pos,
    ListFields.closed,
    ListFields.subscribed,
  ];

  @override
  FutureOr<void> run() async =>
      (await TaskEither.fromEither(boardId.map(boardClient))
              .flatMap(getLists)
              .map((lists) => tabulateObjects(lists, fields))
              .run())
          .collapse(printOutput);

  TaskEither<Failure, List<TrelloList>> getLists(BoardClient boardClient) =>
      boardClient.getLists(fields: fields);

  BoardClient boardClient(BoardId boardId) => client.board(boardId);
}
