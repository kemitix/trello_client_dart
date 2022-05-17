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
  FutureOr<void> run() async => (await Either.sequenceFuture(cardId
          .map((cardId) => client.card(cardId))
          .map((client) => client.attachments(fields: fields))))
      .flatMap(id)
      .map((attachments) => tabulateObjects(attachments, fields))
      .collapse(printOutput);
}
