import 'dart:async' show FutureOr;

import 'package:trello_sdk/trello_sdk.dart'
    show AttachmentFields, CollapsableEither, Either, Failure, left;

import '../commands.dart' show CommandEnvironment, UpdateProperty;
import 'card_module.dart' show CardCommand;

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
