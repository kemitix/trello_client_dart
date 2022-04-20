import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:trello_sdk/trello_cli.dart';

class BoardModule extends Command {
  @override
  final String name = 'board';
  @override
  final String description = 'Trello Boards';

  BoardModule(TrelloClient client) {
    [ListListsCommand(client)].forEach(addSubcommand);
  }
}

abstract class BoardCommand extends TrelloCommand {
  BoardCommand(String name, String description, TrelloClient client)
      : super(name, description, client);

  BoardId get boardId {
    if (parameters.isEmpty) {
      usageException('Board Id was nto given');
    }
    return BoardId(parameters.first);
  }
}

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
