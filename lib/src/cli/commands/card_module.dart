import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:dartz/dartz.dart';

import '../../../trello_sdk.dart';
import '../cli.dart';

class CardModule extends Command {
  @override
  final String name = 'card';
  @override
  final String description = 'Trello Cards';

  CardModule(TrelloClient client) {
    [
      GetCardCommand(client),
      ListAttachmentsCommand(client),
      GetAttachmentCommand(client),
      DownloadAttachmentCommand(client),
    ].forEach(addSubcommand);
  }
}

abstract class CardCommand extends TrelloCommand {
  CardCommand(String name, String description, TrelloClient client)
      : super(name, description, client);

  Either<Failure, CardId> get cardId =>
      nextParameter('Card Id').map((id) => CardId(id));

  Either<Failure, AttachmentId> get attachmentId =>
      nextParameter('Attachment Id').map((id) => AttachmentId(id));

  Either<Failure, FileName> get fileName =>
      nextParameter('File name').map((fileName) => FileName(fileName));
}

class GetCardCommand extends CardCommand {
  GetCardCommand(TrelloClient client) : super('get', 'Get a Card', client);

  final List<CardFields> fields = [
    CardFields.id,
    CardFields.name,
    CardFields.pos,
    CardFields.due,
  ];

  @override
  FutureOr<void> run() async =>
      (await Either.sequenceFuture(cardId.map(doGetCard)))
          .flatMap(id)
          .map((card) => tabulateObject(card, fields))
          .fold(
            (failure) => print(failure.message),
            (table) => print(table),
          );

  Future<Either<Failure, TrelloCard>> doGetCard(cardId) =>
      client.card(cardId).get();
}

class ListAttachmentsCommand extends CardCommand {
  ListAttachmentsCommand(TrelloClient client)
      : super('list-attachments', 'List Attachments on a Card', client);

  final List<AttachmentFields> fields = [
    AttachmentFields.id,
    AttachmentFields.name,
    AttachmentFields.mimeType,
    AttachmentFields.bytes,
  ];

  @override
  FutureOr<void> run() async => (await getAttachments())
      .map((attachments) => tabulateObjects(attachments, fields))
      .fold(
        (failure) => print(failure),
        (table) => print(table),
      );

  Future<Either<Failure, List<TrelloAttachment>>> getAttachments() async =>
      (await Either.sequenceFuture(cardId.map(
              (cardId) => client.card(cardId).getAttachments(fields: fields))))
          .flatMap(id);
}

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
  FutureOr<void> run() async => (await Either.sequenceFuture(
          Either.map2(cardId, attachmentId, doGetAttachment)))
      .flatMap(id)
      .map((attachment) => tabulateObject(attachment, fields))
      .fold(
        (failure) => print(failure),
        (table) => print(table),
      );

  Future<Either<Failure, TrelloAttachment>> doGetAttachment(
          CardId cardId, AttachmentId attachmentId) async =>
      client.card(cardId).attachment(attachmentId).get(fields: fields);
}

/// download-attachment $CARD_ID $ATTACHMENT_ID $FILE_NAME
class DownloadAttachmentCommand extends CardCommand {
  DownloadAttachmentCommand(TrelloClient client)
      : super('download-attachment', 'Download an Attachment file', client);

  @override
  FutureOr<void> run() async => (await Either.sequenceFuture(
          Either.map3(cardId, attachmentId, fileName, doDownload)))
      .flatMap(id)
      .fold(
        (failure) => print('ERROR: ${failure.message}'),
        (r) => print("Download complete"),
      );

  Future<Either<Failure, void>> doDownload(
          CardId cardId, AttachmentId attachmentId, FileName fileName) =>
      client.card(cardId).attachment(attachmentId).download(fileName);
}
