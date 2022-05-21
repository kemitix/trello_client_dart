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
    argParser.addOption('member-ids',
        help: 'Comma-separated list of member IDs');
    argParser.addOption('attachment-cover-id',
        help:
            'The ID of the image attachment the card should use as its cover, or blank for none');
    argParser.addOption('list-id',
        help: 'The ID of the list the card should be in');
    argParser.addOption('label-ids', help: 'Comma-separated list of label IDs');
    argParser.addOption('board-id',
        help: 'The ID of the board the card should be on');
    argParser.addOption('pos',
        help:
            'The position of the card in its list. top, bottom, or a positive float');
    argParser.addOption('due', help: 'When the card is due, or blank');
    argParser.addFlag('due-complete',
        help: 'Whether the due date should be marked complete');
    argParser.addFlag('subscribed',
        help: 'Whether the member is should be subscribed to the card');
    argParser.addOption('address', help: 'For use with/by the Map View');
    argParser.addOption('location-name', help: 'For use with/by the Map View');
    argParser.addOption('coordinates',
        help: 'For use with/by the Map View. Should be latitude,longitude');
    argParser.addOption('cover', help: '''Updates the card's cover:
- color       : pink, yellow, lime, blue, black, orange, red, purple, sky, green (Makes the cover a solid color)
- brightness  : dark, light (Determines whether the text on the cover should be dark or light)
- url         : An unsplash URL: https://images.unsplash.com (Used if making an image the cover. Only Unsplash URLs work)
- idAttachment: ID of an attachment on the card (Used if setting an attached image as the cover)
- size        : normal, full (Determines whether to show the card name on the cover, or below it)''');
  }

  @override
  FutureOr<void> run() => Either.sequenceFuture(
          cardId.map((cardId) => client.card(cardId).put(_updates())))
      .onError((Failure error, stackTrace) => left(error))
      .then((result) => result.map((_) => "Updated").collapse(printOutput));

  Map<String, String> _updates() {
    var updates = <String, String>{};
    var argToApi = <String, String>{
      'name': 'name',
      'desc': 'desc',
      'closed': 'closed',
      'member-ids': 'idMembers',
      'attachment-cover-id': 'idAttachmentCover',
      'list-id': 'idList',
      'label-ids': 'idLabels',
      'board-id': 'idBoard',
      'pos': 'pos',
      'due': 'due',
      'due-complete': 'dueComplete',
      'subscribed': 'subscribed',
      'address': 'address',
      'location-name': 'locationName',
      'coordinates': 'coordinates',
      'cover': 'cover',
    };
    argToApi.keys.where((key) => argResults!.wasParsed(key)).forEach((key) {
      var api = argToApi[key]!;
      updates[api] = argResults![key].toString();
    });
    return updates;
  }
}
