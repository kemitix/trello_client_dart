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
  FutureOr<void> run() => TaskEither.map1Either(listId, _getCards)
      .map((cards) => tabulateObjects(cards, fields))
      .run()
      .then((value) => value.collapse(printOutput));

  TaskEither<Failure, List<TrelloCard>> _getCards(ListId listId) =>
      client.list(listId).getCards(fields: fields);
}
