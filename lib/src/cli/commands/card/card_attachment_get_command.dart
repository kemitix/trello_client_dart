import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../cli.dart';

class GetAttachmentCommand extends CardCommand {
  GetAttachmentCommand(CommandEnvironment commandEnvironment)
      : super('get-attachment', 'Get an Attachment on a Card',
            commandEnvironment);

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
          .map((client) => client.get(fields: fields)))
      .onError((Failure error, stackTrace) => left(error))
      .then((result) => result
          .map((attachment) => tabulateObject(attachment, fields))
          .collapse(printOutput));
}
