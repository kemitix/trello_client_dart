import 'dart:async';

import '../../../../trello_sdk.dart';
import 'card_module.dart';

class ListAttachmentsCommand extends CardCommand {
  ListAttachmentsCommand(TrelloClient client)
      : super('list-attachments', 'List Attachments on a Card', client);

  final List<AttachmentFields> fields = [
    AttachmentFields.id,
    AttachmentFields.name,
    AttachmentFields.mimeType,
    AttachmentFields.bytes,
  ];

  @override
  FutureOr<void> run() async =>
      (await TaskEither.fromEither(cardId).flatMap(_getAttachments).run())
          .map((attachments) => tabulateObjects(attachments, fields))
          .collapse(printOutput);

  TaskEither<Failure, List<TrelloAttachment>> _getAttachments(cardId) =>
      client.card(cardId).attachments(fields: fields);
}
