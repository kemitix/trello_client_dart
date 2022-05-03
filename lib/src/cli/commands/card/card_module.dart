import 'package:args/command_runner.dart';

import '../../../../trello_sdk.dart';
import '../commands.dart';
import 'card_attachment_download_command.dart';
import 'card_attachment_get_command.dart';
import 'card_attachments_list_command.dart';
import 'card_get_command.dart';
import 'card_member_add_command.dart';
import 'card_update_command.dart';

class CardModule extends Command {
  @override
  final String name = 'card';

  @override
  final String description = 'Trello Cards';

  CardModule(CommandEnvironment commandEnvironment) {
    [
      GetCardCommand(commandEnvironment),
      ListAttachmentsCommand(commandEnvironment),
      GetAttachmentCommand(commandEnvironment),
      DownloadAttachmentCommand(commandEnvironment),
      UpdateCardCommand(commandEnvironment),
      AddMemberToCardCommand(commandEnvironment),
    ].forEach(addSubcommand);
  }
}

abstract class CardCommand extends TrelloCommand {
  CardCommand(
      String name, String description, CommandEnvironment commandEnvironment)
      : super(name, description, commandEnvironment);

  Either<Failure, CardId> get cardId =>
      nextParameter('Card Id').map((id) => CardId(id));

  Either<Failure, AttachmentId> get attachmentId =>
      nextParameter('Attachment Id').map((id) => AttachmentId(id));

  Either<Failure, FileName> get fileName =>
      nextParameter('File name').map((fileName) => FileName(fileName));
}
