import 'dart:async' show FutureOr;

import 'package:trello_client/trello_sdk.dart'
    show
        AttachmentFields,
        AttachmentId,
        CardId,
        CollapsableEither,
        Either,
        Failure,
        left,
        map2either;

import '../commands.dart' show CommandEnvironment, UpdateProperty;
import 'card_module.dart' show CardCommand;

class GetAttachmentCommand extends CardCommand {
  GetAttachmentCommand(CommandEnvironment commandEnvironment)
      : super('get-attachment', 'Get an Attachment on a Card',
            commandEnvironment) {
    addFieldsOption(fields);
  }

  final List<AttachmentFields> fields = [
    AttachmentFields.id,
    AttachmentFields.name,
    AttachmentFields.mimeType,
    AttachmentFields.bytes,
    AttachmentFields.url,
  ];

  @override
  FutureOr<void> run() => Either.sequenceFuture(map2either(
              cardId,
              attachmentId,
              (CardId cardId, AttachmentId attachmentId) =>
                  client.card(cardId).attachment(attachmentId))
          .map((client) => client.get(fields: getFields())))
      .onError((Failure error, stackTrace) => left(error))
      .then((result) => result
          .map((attachment) => tabulateObject(attachment, getFields()))
          .collapse(printOutput));

  List<AttachmentFields> getFields() =>
      getEnumFields(enumValues: AttachmentFields.values, defaults: fields);

  @override
  List<UpdateProperty> get updateProperties => [];
}
