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
  FutureOr<void> run() => TaskEither.map1Either(boardId,
          (BoardId boardId) => client.board(boardId).getLists(fields: fields))
      .map((lists) => tabulateObjects(lists, fields))
      .run()
      .then((result) => result.collapse(printOutput));
}
