import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../cli.dart';

class GetCardCommand extends CardCommand {
  GetCardCommand(CommandEnvironment commandEnvironment)
      : super('get', 'Get a Card', commandEnvironment) {
    addFieldsOption(fields);
  }

  final List<CardFields> fields = [
    CardFields.id,
    CardFields.name,
    CardFields.pos,
    CardFields.due,
    CardFields.idMembers,
  ];

  @override
  FutureOr<void> run() => Either.sequenceFuture(
          cardId.map((cardId) => client.card(cardId).get(fields: getFields())))
      .onError((Failure error, stackTrace) => left(error))
      .then((result) => result
          .map((card) => tabulateObject(card, getFields()))
          .collapse(printOutput));

  List<CardFields> getFields() =>
      getEnumFields(enumValues: CardFields.values, defaults: fields);

  @override
  List<UpdateProperty> get updateProperties => [];
}
