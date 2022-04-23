import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../trello_sdk.dart';
import 'card_module.dart';

/// download-attachment $CARD_ID $ATTACHMENT_ID $FILE_NAME
class DownloadAttachmentCommand extends CardCommand {
  DownloadAttachmentCommand(TrelloClient client)
      : super('download-attachment', 'Download an Attachment file', client);

  @override
  FutureOr<void> run() async =>
      (await _download(cardId, attachmentId, fileName).unwrapFuture())
          .map((r) => 'Download complete')
          .collapse(printOutput);

  Function3<
          Either<Failure, CardId>,
          Either<Failure, AttachmentId>,
          Either<Failure, FileName>,
          Either<Failure, Future<Either<Failure, void>>>>
      get _download => Either.lift3(_doDownload);

  Future<Either<Failure, void>> _doDownload(
          CardId cardId, AttachmentId attachmentId, FileName fileName) =>
      client.card(cardId).attachment(attachmentId).download(fileName);
}
