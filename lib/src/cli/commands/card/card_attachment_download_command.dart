import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../trello_sdk.dart';
import 'card_module.dart';

/// download-attachment $CARD_ID $ATTACHMENT_ID $FILE_NAME
class DownloadAttachmentCommand extends CardCommand {
  DownloadAttachmentCommand(TrelloClient client)
      : super('download-attachment', 'Download an Attachment file', client);

  @override
  FutureOr<void> run() async => (await Either.sequenceFuture(
          Either.lift3(doDownload)(cardId, attachmentId, fileName)))
      .flatMap(id)
      .fold(
        (failure) => print(failure),
        (r) => print("Download complete"),
      );

  Future<Either<Failure, void>> doDownload(
          CardId cardId, AttachmentId attachmentId, FileName fileName) =>
      client.card(cardId).attachment(attachmentId).download(fileName);
}
