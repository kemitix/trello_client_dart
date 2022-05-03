import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../cli.dart';

class ListCardsCommand extends ListCommand {
  ListCardsCommand(CommandEnvironment commandEnvironment)
      : super('list-cards', 'Get Cards in a List', commandEnvironment);

  final List<CardFields> fields = [
    CardFields.id,
    CardFields.name,
    CardFields.pos,
    CardFields.due,
  ];

  @override
  FutureOr<void> run() async =>
      (await taskEitherFlatE(listId.map(_listClient).map(_getCardsTE))
              .map((cards) => tabulateObjects(cards, fields))
              .run())
          .collapse(printOutput);

  TaskEither<Failure, List<TrelloCard>> _getCardsTE(ListClient listClient) =>
      listClient.getCards(fields: fields);

  ListClient _listClient(ListId listId) => client.list(listId);
}
