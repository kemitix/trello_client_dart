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
  FutureOr<void> run() async =>
      (await TaskEither.fromEither(cardId).flatMap(_getCard).run())
          .map((card) => tabulateObject(card, fields))
          .collapse(printOutput);

  TaskEither<Failure, TrelloCard> _getCard(cardId) =>
      client.card(cardId).get(fields: fields);
}
