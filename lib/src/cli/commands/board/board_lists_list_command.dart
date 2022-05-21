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
  FutureOr<void> run() => Either.sequenceFuture(boardId.map((boardId) => client
          .board(boardId)
          .getLists(fields: fields)
          .then((lists) => tabulateObjects(lists, fields))))
      .then((result) => result.collapse(printOutput));
}
