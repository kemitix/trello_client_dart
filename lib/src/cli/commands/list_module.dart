import 'dart:async';

import 'package:args/command_runner.dart';

import '../../../trello_sdk.dart';
import '../cli.dart';

class ListModule extends Command {
  @override
  final String name = 'list';
  @override
  final String description = 'Trello Lists';

  ListModule(TrelloClient client) {
    <Command>[ListCardsCommand(client)].forEach(addSubcommand);
  }
}

abstract class ListCommand extends TrelloCommand {
  ListCommand(String name, String description, TrelloClient client)
      : super(name, description, client);
  ListId get listId {
    if (parameters.isEmpty) {
      usageException('List Id was not given');
    }
    return ListId(parameters.first);
  }
}

class ListCardsCommand extends ListCommand {
  ListCardsCommand(TrelloClient client)
      : super('list-cards', 'Get Cards in a List', client);

  final List<CardFields> fields = [
    CardFields.id,
    CardFields.name,
    CardFields.pos,
    CardFields.due,
  ];

  @override
  FutureOr<void> run() async {
    List<Card> cards = await client.list(listId).getCards(fields: fields);
    print(tabulateObjects(cards, fields));
  }
}
