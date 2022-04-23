import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../trello_sdk.dart';
import 'card_module.dart';

class UpdateCardCommand extends CardCommand {
  UpdateCardCommand(TrelloClient client)
      : super('update', 'Update a Card', client) {
    argParser.addOption(
      'name',
      help: 'The new name for the card',
    );
  }

  FutureOr<void> run() async => (await unwrapFuture(cardId
          .map((cardId) => cardClient(cardId))
          .map((cardClient) async => (await unwrapFuture(
              (await getOriginalCard(cardClient))
                  .map((card) => updateCard(card, getUpdates()))
                  .map((card) => putCard(cardClient, card)))))))
      .map((r) => "Updated")
      .collapse(printOutput);

  TrelloCard updateCard(TrelloCard original, Map<String, String> updates) {
    var copy = original.raw;
    updates.keys.forEach((key) {
      copy.update(key, (value) => updates[key]);
    });
    return TrelloCard(copy, original.fields);
  }

  Map<String, String> getUpdates() {
    var updates = <String, String>{};
    ['name'].forEach((element) {
      if (argResults!.wasParsed(element)) {
        updates[element] = argResults![element];
      }
    });
    return updates;
  }

  Future<Either<Failure, TrelloCard>> putCard(
          CardClient cardClient, TrelloCard card) async =>
      cardClient.put(card);

  CardClient cardClient(CardId cardId) => client.card(cardId);

  Future<Either<Failure, TrelloCard>> getOriginalCard(
          CardClient cardClient) async =>
      cardClient.get();
}
