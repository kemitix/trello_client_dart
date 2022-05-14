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
  FutureOr<void> run() => TaskEither.map2Either(
          cardId,
          attachmentId,
          (CardId cardId, AttachmentId attachmentId) =>
              client.card(cardId).attachment(attachmentId).get(fields: fields))
      .run()
      .then((result) => result
          .map((attachment) => tabulateObject(attachment, fields))
          .collapse(printOutput));
}
