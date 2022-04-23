import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:trello_sdk/src/cli/cli.dart';
import 'package:trello_sdk/src/sdk/cards/card_client.dart';
import 'package:trello_sdk/src/sdk/cards/card_models.dart';
import 'package:trello_sdk/src/sdk/client.dart';
import 'package:trello_sdk/src/sdk/errors.dart';

class UpdateCardCommand extends CardCommand {
  UpdateCardCommand(TrelloClient client)
      : super('update', 'Update a Card', client) {
    argParser.addOption(
      'name',
      help: 'The new name for the card',
    );
  }

  FutureOr<void> run() async => (await Either.sequenceFuture(cardId
          .map((cardId) => cardClient(cardId))
          .map((cardClient) async => (await Either.sequenceFuture(
                  (await getOriginalCard(cardClient))
                      .map((card) => updateCard(card, getUpdates()))
                      .map((card) => putCard(cardClient, card))))
              .flatMap(id))))
      .flatMap(id)
      .fold(
        (failure) => print(failure.message),
        (card) => print("Updated"),
      );

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
