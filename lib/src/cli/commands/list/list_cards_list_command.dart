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
  FutureOr<void> run() async => (await Either.sequenceFuture(listId
          .map((ListId listId) => client.list(listId))
          .map((client) => client.getCards(fields: fields))))
      .flatMap(id)
      .map((cards) => tabulateObjects(cards, fields))
      .collapse(printOutput);
}
