import 'dart:async';

import '../../../../trello_sdk.dart';
import 'card_module.dart';

/// download-attachment $CARD_ID $ATTACHMENT_ID $FILE_NAME
class DownloadAttachmentCommand extends CardCommand {
  DownloadAttachmentCommand(TrelloClient client)
      : super('download-attachment', 'Download an Attachment file', client);

  @override
  FutureOr<void> run() async =>
      (await taskEitherFlatE(_download(cardId, attachmentId, fileName)).run())
          .map((_) => "Download complete")
          .collapse(printOutput);

  Function3<Either<Failure, CardId>, Either<Failure, AttachmentId>,
          Either<Failure, FileName>, Either<Failure, TaskEither<Failure, void>>>
      get _download => lift3either(_doDownload);

  TaskEither<Failure, void> _doDownload(
          CardId cardId, AttachmentId attachmentId, FileName fileName) =>
      client.card(cardId).attachment(attachmentId).download(fileName);
}
