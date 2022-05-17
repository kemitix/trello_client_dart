import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../cli.dart';

/// download-attachment $CARD_ID $ATTACHMENT_ID $FILE_NAME
class DownloadAttachmentCommand extends CardCommand {
  DownloadAttachmentCommand(CommandEnvironment commandEnvironment)
      : super('download-attachment', 'Download an Attachment file',
            commandEnvironment);

  @override
  FutureOr<void> run() async => (await Either.sequenceFuture(map2either(
          cardId,
          attachmentId,
          (CardId cardId, AttachmentId attachmentId) =>
              client.card(cardId).attachment(attachmentId)).map((client) =>
          Either.sequenceFuture(
              fileName.map((fileName) => client.download(fileName))))))
      .flatMap(id)
      .flatMap(id)
      .replace("Download complete")
      .collapse(printOutput);
}
