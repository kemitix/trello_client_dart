import 'package:trello_sdk/trello_sdk.dart' show Either, Failure, MemberId;

import '../commands.dart' show CommandEnvironment, TrelloCommand, TrelloModule;
import 'member_boards_list_command.dart' show ListMemberBoardsCommand;
import 'member_get_command.dart' show GetMemberCommand;

class MemberModule extends TrelloModule {
  @override
  final String name = 'member';
  @override
  final String description = 'Trello Members (users)';

  MemberModule(CommandEnvironment commandEnvironment)
      : super(commandEnvironment) {
    [
      GetMemberCommand(commandEnvironment),
      ListMemberBoardsCommand(commandEnvironment),
    ].forEach(addSubcommand);
  }
}

abstract class MemberCommand extends TrelloCommand {
  MemberCommand(super.name, super.description, super.commandEnvironment);

  Either<Failure, MemberId> get memberId =>
      nextParameter('Member Id').map((id) => MemberId(id));
}
