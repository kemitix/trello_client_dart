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
  ];

  @override
  FutureOr<void> run() async =>
      (await Either.sequenceFuture(cardId.map(doGetCard)))
          .flatMap(id)
          .map((card) => tabulateObject(card, fields))
          .fold(
            (failure) => print(failure.message),
            (table) => print(table),
          );

  Future<Either<Failure, TrelloCard>> doGetCard(cardId) =>
      client.card(cardId).get();
}
