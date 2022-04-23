import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../trello_sdk.dart';
import 'card_module.dart';

class GetAttachmentCommand extends CardCommand {
  GetAttachmentCommand(TrelloClient client)
      : super('get-attachment', 'Get an Attachment on a Card', client);

  final List<AttachmentFields> fields = [
    AttachmentFields.id,
    AttachmentFields.name,
    AttachmentFields.mimeType,
    AttachmentFields.bytes,
    AttachmentFields.url,
  ];

  @override
  FutureOr<void> run() async =>
      (await unwrapFuture(_getAttachment(cardId, attachmentId)))
          .map((attachment) => tabulateObject(attachment, fields))
          .collapse(printOutput);

  Function2<Either<Failure, CardId>, Either<Failure, AttachmentId>,
          Either<Failure, Future<Either<Failure, TrelloAttachment>>>>
      get _getAttachment => Either.lift2(doGetAttachment);

  Future<Either<Failure, TrelloAttachment>> doGetAttachment(
          CardId cardId, AttachmentId attachmentId) async =>
      client.card(cardId).attachment(attachmentId).get(fields: fields);
}
