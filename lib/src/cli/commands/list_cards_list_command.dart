import 'dart:async';

import '../../../trello_sdk.dart';
import 'list_module.dart';

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
    (await client.list(listId).getCards(fields: fields))
        .map((r) => tabulateObjects(r, fields))
        .fold(
          (failure) => print(failure),
          (table) => print(table),
        );
  }
}
