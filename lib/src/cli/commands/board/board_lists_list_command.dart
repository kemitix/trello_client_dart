import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../cli.dart';

class ListListsCommand extends BoardCommand {
  ListListsCommand(CommandEnvironment commandEnvironment)
      : super('list-lists', 'Get Lists on a Board', commandEnvironment);

  final List<ListFields> fields = [
    ListFields.id,
    ListFields.name,
    ListFields.pos,
    ListFields.closed,
    ListFields.subscribed,
  ];

  @override
  FutureOr<void> run() => TaskEither.fromEither(boardId.map(boardClient))
      .flatMap(getLists)
      .map((lists) => tabulateObjects(lists, fields))
      .run()
      .then((value) => value.collapse(printOutput));

  TaskEither<Failure, List<TrelloList>> getLists(BoardClient boardClient) =>
      boardClient.getLists(fields: fields);

  BoardClient boardClient(BoardId boardId) => client.board(boardId);
}
