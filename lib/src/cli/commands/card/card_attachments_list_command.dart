import 'dart:async';

import 'package:dartz/dartz.dart';

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
      (await cardId.map(_getAttachments).unwrapFuture())
          .map((attachments) => tabulateObjects(attachments, fields))
          .collapse(printOutput);

  Future<Either<Failure, List<TrelloAttachment>>> _getAttachments(cardId) =>
      client.card(cardId).attachments(fields: fields);
}
