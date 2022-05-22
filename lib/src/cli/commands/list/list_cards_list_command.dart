import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../cli.dart';

class ListCardsCommand extends ListCommand {
  ListCardsCommand(CommandEnvironment commandEnvironment)
      : super('list-cards', 'Get Cards in a List', commandEnvironment) {
    addFieldsOption(fields);
  }

  final List<CardFields> fields = [
    CardFields.id,
    CardFields.name,
    CardFields.pos,
    CardFields.due,
  ];

  @override
  FutureOr<void> run() => Either.sequenceFuture(listId
          .map((listId) => client.list(listId).getCards(fields: getFields())))
      .onError((Failure error, stackTrace) => left(error))
      .then((result) => result
          .map((cards) => tabulateObjects(cards, getFields()))
          .collapse(printOutput));

  List<CardFields> getFields() =>
      getEnumFields(enumValues: CardFields.values, defaults: fields);

  @override
  //TODO add fields override
  List<UpdateProperty> get updateProperties => [];
}
