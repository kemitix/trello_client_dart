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
      (await taskEitherFlatE(_getAttachment(cardId, attachmentId)).run())
          .map((attachment) => tabulateObject(attachment, fields))
          .collapse(printOutput);

  Function2<Either<Failure, CardId>, Either<Failure, AttachmentId>,
          Either<Failure, TaskEither<Failure, TrelloAttachment>>>
      get _getAttachment => lift2either(doGetAttachment);

  TaskEither<Failure, TrelloAttachment> doGetAttachment(
          CardId cardId, AttachmentId attachmentId) =>
      client.card(cardId).attachment(attachmentId).get(fields: fields);
}
