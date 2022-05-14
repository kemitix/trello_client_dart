import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../cli.dart';

/// download-attachment $CARD_ID $ATTACHMENT_ID $FILE_NAME
class DownloadAttachmentCommand extends CardCommand {
  DownloadAttachmentCommand(CommandEnvironment commandEnvironment)
      : super('download-attachment', 'Download an Attachment file',
            commandEnvironment);

  @override
  FutureOr<void> run() async =>
      (await TaskEither.map3Either(cardId, attachmentId, fileName, _doDownload)
              .run())
          .map((_) => "Download complete")
          .collapse(printOutput);

  TaskEither<Failure, void> _doDownload(
          CardId cardId, AttachmentId attachmentId, FileName fileName) =>
      client.card(cardId).attachment(attachmentId).download(fileName);
}
