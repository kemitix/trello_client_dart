import 'dart:async' show FutureOr;

import 'package:trello_sdk/trello_sdk.dart'
    show CollapsableEither, Either, Failure, left;

import '../commands.dart'
    show CommandEnvironment, UpdateFlag, UpdateOption, UpdateProperty;
import 'card_module.dart' show CardCommand;

class UpdateCardCommand extends CardCommand {
  UpdateCardCommand(CommandEnvironment commandEnvironment)
      : super('update', 'Update a Card', commandEnvironment);

  @override
  List<UpdateProperty> get updateProperties => <UpdateProperty>[
        UpdateOption('name', help: 'The new name for the card'),
        UpdateOption('desc', help: 'The new description for the card'),
        UpdateOption('member-ids',
            query: 'member-ids', help: 'Comma-separated list of member IDs'),
        UpdateFlag('closed',
            help: 'Whether the card should be archived (closed: true)'),
        UpdateOption('attachment-cover-id',
            query: 'idAttachmentCover',
            help:
                'The ID of the image attachment the card should use as its cover, or blank for none'),
        UpdateOption('list-id',
            query: 'idList', help: 'The ID of the list the card should be in'),
        UpdateOption('label-ids',
            query: 'idLabels', help: 'Comma-separated list of label IDs'),
        UpdateOption('board-id',
            query: 'idBoard',
            help: 'The ID of the board the card should be on'),
        UpdateOption('pos',
            help:
                'The position of the card in its list. top, bottom, or a positive float'),
        UpdateOption('due', help: 'When the card is due, or blank'),
        UpdateFlag('due-complete',
            query: 'dueComplete',
            help: 'Whether the due date should be marked complete'),
        UpdateFlag('subscribed',
            help: 'Whether the member is should be subscribed to the card'),
        UpdateOption('address', help: 'For use with/by the Map View'),
        UpdateOption('location-name',
            query: 'locationName', help: 'For use with/by the Map View'),
        UpdateOption('coordinates',
            help: 'For use with/by the Map View. Should be latitude,longitude'),
        UpdateOption('cover', help: '''Updates the card's cover:
- color       : pink, yellow, lime, blue, black, orange, red, purple, sky, green (Makes the cover a solid color)
- brightness  : dark, light (Determines whether the text on the cover should be dark or light)
- url         : An unsplash URL: https://images.unsplash.com (Used if making an image the cover. Only Unsplash URLs work)
- idAttachment: ID of an attachment on the card (Used if setting an attached image as the cover)
- size        : normal, full (Determines whether to show the card name on the cover, or below it)'''),
      ];

  @override
  FutureOr<void> run() => Either.sequenceFuture(
          cardId.map((cardId) => client.card(cardId).put(updates())))
      .onError((Failure error, stackTrace) => left(error))
      .then((result) => result.map((_) => "Updated").collapse(printOutput));
}
