import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../cli.dart';

class GetCardCommand extends CardCommand {
  GetCardCommand(CommandEnvironment commandEnvironment)
      : super('get', 'Get a Card', commandEnvironment);

  final List<CardFields> fields = [
    CardFields.id,
    CardFields.name,
    CardFields.pos,
    CardFields.due,
    CardFields.idMembers,
  ];

  @override
  FutureOr<void> run() async => (await Either.sequenceFuture(cardId
          .map((cardId) => client.card(cardId))
          .map((client) => client.get(fields: fields))))
      .flatMap(id)
      .map((card) => tabulateObject(card, fields))
      .collapse(printOutput);
}
