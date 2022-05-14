import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../cli.dart';

class ListAttachmentsCommand extends CardCommand {
  ListAttachmentsCommand(CommandEnvironment commandEnvironment)
      : super('list-attachments', 'List Attachments on a Card',
            commandEnvironment);

  final List<AttachmentFields> fields = [
    AttachmentFields.id,
    AttachmentFields.name,
    AttachmentFields.mimeType,
    AttachmentFields.bytes,
  ];

  @override
  FutureOr<void> run() => TaskEither.map1Either(cardId,
          (CardId cardId) => client.card(cardId).attachments(fields: fields))
      .run()
      .then((result) => result
          .map((attachments) => tabulateObjects(attachments, fields))
          .collapse(printOutput));
}
