import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../cli.dart';

class UpdateCardCommand extends CardCommand {
  UpdateCardCommand(CommandEnvironment commandEnvironment)
      : super('update', 'Update a Card', commandEnvironment) {
    argParser.addOption('name', help: 'The new name for the card');
    argParser.addOption('desc', help: 'The new description for the card');
    argParser.addFlag('closed',
        help: 'Whether the card should be archived (closed: true)');
    argParser.addOption('idMembers',
        help: 'Comma-separated list of member IDs');
    argParser.addOption('idAttachmentCover',
        help:
            'The ID of the image attachment the card should use as its cover, or blank for none');
    argParser.addOption('idList',
        help: 'The ID of the list the card should be in');
    argParser.addOption('idLabels', help: 'Comma-separated list of label IDs');
    argParser.addOption('idBoard',
        help: 'The ID of the board the card should be on');
    argParser.addOption('pos',
        help:
            'The position of the card in its list. top, bottom, or a positive float');
    argParser.addOption('due', help: 'When the card is due, or blank');
    argParser.addFlag('dueComplete',
        help: 'Whether the due date should be marked complete');
    argParser.addFlag('subscribed',
        help: 'Whether the member is should be subscribed to the card');
    argParser.addOption('address', help: 'For use with/by the Map View');
    argParser.addOption('locationName', help: 'For use with/by the Map View');
    argParser.addOption('coordinates',
        help: 'For use with/by the Map View. Should be latitude,longitude');
    argParser.addOption('cover', help: '''Updates the card\'s cover:
- color       : pink, yellow, lime, blue, black, orange, red, purple, sky, green (Makes the cover a solid color)
- brightness  : dark, light (Determines whether the text on the cover should be dark or light)
- url         : An unsplash URL: https://images.unsplash.com (Used if making an image the cover. Only Unsplash URLs work)
- idAttachment: ID of an attachment on the card (Used if setting an attached image as the cover)
- size        : normal, full (Determines whether to show the card name on the cover, or below it)''');
  }

  FutureOr<void> run() async => cardId
      .map(_cardClient)
      .map(_updateCardTE)
      .map((r) => "Updated")
      .collapse(printOutput);

  TaskEither<Failure, TrelloCard> _updateCardTE(cardClient) =>
      TaskEither.flatten(_getOriginalCardTE(cardClient)
          .map((card) => _updateCard(card, _getUpdates()))
          .map((card) => _putCardTE(cardClient, card)));

  TaskEither<Failure, TrelloCard> _putCardTE(
          CardClient cardClient, TrelloCard card) =>
      cardClient.put(card);

  TaskEither<Failure, TrelloCard> _getOriginalCardTE(CardClient cardClient) =>
      cardClient.get();

  TrelloCard _updateCard(TrelloCard original, Map<String, String> updates) {
    var copy = original.raw;
    updates.keys.forEach((key) {
      copy.update(key, (value) => updates[key]);
    });
    return TrelloCard(copy, original.fields);
  }

  CardClient _cardClient(CardId cardId) => client.card(cardId);

  Map<String, String> _getUpdates() {
    var updates = <String, String>{};
    [
      'name',
      'desc',
      'closed',
      'idMembers',
      'idAttachmentCover',
      'idList',
      'idLabels',
      'idBoard',
      'pos',
      'due',
      'dueComplete',
      'subscribed',
      'address',
      'locationName',
      'coordinates',
      'cover',
    ].forEach((element) {
      if (argResults!.wasParsed(element)) {
        updates[element] = argResults![element].toString();
      }
    });
    return updates;
  }
}
