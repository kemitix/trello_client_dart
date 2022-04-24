import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../trello_sdk.dart';
import 'card_module.dart';

class GetCardCommand extends CardCommand {
  GetCardCommand(TrelloClient client) : super('get', 'Get a Card', client);

  final List<CardFields> fields = [
    CardFields.id,
    CardFields.name,
    CardFields.pos,
    CardFields.due,
    CardFields.idMembers,
  ];

  @override
  FutureOr<void> run() async => (await cardId.map(doGetCard).unwrapFuture())
      .map((card) => tabulateObject(card, fields))
      .collapse(printOutput);

  Future<Either<Failure, TrelloCard>> doGetCard(cardId) =>
      client.card(cardId).get();
}
