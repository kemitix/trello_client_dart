import 'package:trello_sdk/trello_sdk.dart'
    show AttachmentId, CardId, Either, Failure, FileName;

import '../commands.dart' show CommandEnvironment, TrelloCommand, TrelloModule;
import 'card_attachment_download_command.dart' show DownloadAttachmentCommand;
import 'card_attachment_get_command.dart' show GetAttachmentCommand;
import 'card_attachments_list_command.dart' show ListAttachmentsCommand;
import 'card_get_command.dart' show GetCardCommand;
import 'card_member_add_command.dart' show AddMemberToCardCommand;
import 'card_member_remove_command.dart' show RemoveMemberFromCardCommand;
import 'card_update_command.dart' show UpdateCardCommand;

class CardModule extends TrelloModule {
  @override
  final String name = 'card';

  @override
  final String description = 'Trello Cards';

  CardModule(CommandEnvironment commandEnvironment)
      : super(commandEnvironment) {
    [
      GetCardCommand(commandEnvironment),
      ListAttachmentsCommand(commandEnvironment),
      GetAttachmentCommand(commandEnvironment),
      DownloadAttachmentCommand(commandEnvironment),
      UpdateCardCommand(commandEnvironment),
      AddMemberToCardCommand(commandEnvironment),
      RemoveMemberFromCardCommand(commandEnvironment),
    ].forEach(addSubcommand);
  }
}

abstract class CardCommand extends TrelloCommand {
  CardCommand(
    super.name,
    super.description,
    super.commandEnvironment,
  );

  Either<Failure, CardId> get cardId =>
      nextParameter('Card Id').map((id) => CardId(id));

  Either<Failure, AttachmentId> get attachmentId =>
      nextParameter('Attachment Id').map((id) => AttachmentId(id));

  Either<Failure, FileName> get fileName =>
      nextParameter('File name').map((fileName) => FileName(fileName));
}
