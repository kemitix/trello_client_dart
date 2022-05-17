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
  FutureOr<void> run() async => (await Either.sequenceFuture(boardId
          .map((boardId) => client.board(boardId))
          .map((client) => client.getLists(fields: fields))))
      .flatMap(id)
      .map((lists) => tabulateObjects(lists, fields))
      .collapse(printOutput);
}
