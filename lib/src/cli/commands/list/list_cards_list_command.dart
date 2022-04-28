import 'dart:async';

import '../../../../trello_sdk.dart';
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
  FutureOr<void> run() async => (await TaskEither.flatten(
              TaskEither.fromEither(listId.map(_listClient).map(_getCardsTE)))
          .map((cards) => tabulateObjects(cards, fields))
          .run())
      .collapse(printOutput);

  TaskEither<Failure, List<TrelloCard>> _getCardsTE(ListClient listClient) =>
      listClient.getCards(fields: fields);

  ListClient _listClient(ListId listId) => client.list(listId);
}
