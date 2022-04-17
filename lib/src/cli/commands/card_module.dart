import 'dart:async';

import 'package:args/command_runner.dart';

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
    ].forEach(addSubcommand);
  }
}

abstract class CardCommand extends TrelloCommand {
  CardCommand(String name, String description, TrelloClient client)
      : super(name, description, client);

  CardId get cardId {
    if (parameters.isEmpty) {
      usageException('Card Id was not given');
    }
    return CardId(parameters.first);
  }
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
    Card? card = await client.card(cardId).get();
    if (card != null) print(tabulateObject(card, fields));
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
    List<Attachment> attachments =
        await client.card(cardId).getAttachments(fields: fields);
    print(tabulateObjects(attachments, fields));
  }
}
