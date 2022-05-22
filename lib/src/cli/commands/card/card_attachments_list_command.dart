import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../cli.dart';

class ListAttachmentsCommand extends CardCommand {
  ListAttachmentsCommand(CommandEnvironment commandEnvironment)
      : super('list-attachments', 'List Attachments on a Card',
            commandEnvironment) {
    addFieldsOption(fields);
  }

  final List<AttachmentFields> fields = [
    AttachmentFields.id,
    AttachmentFields.name,
    AttachmentFields.mimeType,
    AttachmentFields.bytes,
  ];

  @override
  FutureOr<void> run() => Either.sequenceFuture(cardId.map(
          (cardId) => client.card(cardId).attachments(fields: getFields())))
      .onError((Failure error, stackTrace) => left(error))
      .then((result) => result
          .map((attachments) => tabulateObjects(attachments, getFields()))
          .collapse(printOutput));

  List<AttachmentFields> getFields() =>
      getEnumFields(enumValues: AttachmentFields.values, defaults: fields);

  @override
  List<UpdateProperty> get updateProperties => [];
}
