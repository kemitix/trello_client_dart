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
  FutureOr<void> run() async {
    (await client.board(boardId).getLists(fields: fields))
        .map((lists) => tabulateObjects(lists, fields))
        .fold(
          (failure) => print(failure),
          (table) => print(table),
        );
  }
}
