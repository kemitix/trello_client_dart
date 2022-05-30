import 'dart:async' show FutureOr;

import 'package:trello_sdk/trello_sdk.dart'
    show
        AttachmentId,
        CardId,
        CollapsableEither,
        Either,
        Failure,
        FileName,
        left,
        map3either;

import '../commands.dart' show CommandEnvironment, UpdateProperty;
import 'card_module.dart' show CardCommand;

/// download-attachment $CARD_ID $ATTACHMENT_ID $FILE_NAME
class DownloadAttachmentCommand extends CardCommand {
  DownloadAttachmentCommand(CommandEnvironment commandEnvironment)
      : super('download-attachment', 'Download an Attachment file',
            commandEnvironment);

  @override
  FutureOr<void> run() => Either.sequenceFuture(map3either(
          cardId,
          attachmentId,
          fileName,
          (CardId cardId, AttachmentId attachmentId, FileName fileName) =>
              client.card(cardId).attachment(attachmentId).download(fileName)))
      .then((e) => e.replace("Download complete"))
      .onError((Failure error, stackTrace) => left(error))
      .then((result) => result.collapse(printOutput));

  @override
  List<UpdateProperty> get updateProperties => [];
}
