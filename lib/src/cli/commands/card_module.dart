import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:dartz/dartz.dart';

import '../../../trello_sdk.dart';
import '../../sdk/http_client.dart';
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

  CardId get cardId => CardId(nextParameter('Card Id'));

  AttachmentId get attachmentId => AttachmentId(nextParameter('Attachment Id'));

  FileName get fileName => FileName(nextParameter('File name'));
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
  FutureOr<void> run() async {
    (await client.card(cardId).get())
        .flatMap<TrelloCard>((maybeCard) =>
            (maybeCard == null ? Left(Failure()) : Right(maybeCard)))
        .map((card) => tabulateObject(card, fields))
        .fold(
          (failure) => print(failure),
          (table) => print(table),
        );
  }
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
  FutureOr<void> run() async {
    (await client.card(cardId).getAttachments(fields: fields))
        .map((attachments) => tabulateObjects(attachments, fields))
        .fold(
          (failure) => print(failure),
          (table) => print(table),
        );
  }
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
  FutureOr<void> run() async {
    (await client.card(cardId).attachment(attachmentId).get(fields: fields))
        .map((attachment) => tabulateObject(attachment, fields))
        .fold(
          (failure) => print(failure),
          (table) => print(table),
        );
  }
}

/// download-attachment $CARD_ID $ATTACHMENT_ID $FILE_NAME
class DownloadAttachmentCommand extends CardCommand {
  DownloadAttachmentCommand(TrelloClient client)
      : super('download-attachment', 'Download an Attachment file', client);

  @override
  FutureOr<void> run() async {
    await client.card(cardId).attachment(attachmentId).download(fileName);
  }
}
