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
  FutureOr<void> run() async =>
      (await TaskEither.map2Either(cardId, attachmentId, doGetAttachment).run())
          .map((attachment) => tabulateObject(attachment, fields))
          .collapse(printOutput);

  TaskEither<Failure, TrelloAttachment> doGetAttachment(
          CardId cardId, AttachmentId attachmentId) =>
      client.card(cardId).attachment(attachmentId).get(fields: fields);
}
