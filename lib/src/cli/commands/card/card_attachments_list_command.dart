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
  FutureOr<void> run() => Either.sequenceFuture(cardId
          .map((cardId) => client.card(cardId).attachments(fields: fields)))
      .onError((Failure error, stackTrace) => left(error))
      .then((result) => result
          .map((attachments) => tabulateObjects(attachments, fields))
          .collapse(printOutput));

  @override
  //TODO add fields override
  List<UpdateProperty> get updateProperties => [];
}
