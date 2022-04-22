import 'package:args/command_runner.dart';

import '../../../../trello_sdk.dart';
import '../commands.dart';
import 'member_get_command.dart';
import 'member_list_command.dart';

class MemberModule extends Command {
  @override
  final String name = 'member';
  @override
  final String description = 'Trello Members (users)';

  MemberModule(TrelloClient client) {
    [
      GetMemberCommand(client),
      ListMemberBoardsCommand(client),
    ].forEach(addSubcommand);
  }
}

abstract class MemberCommand extends TrelloCommand {
  MemberCommand(String name, String description, TrelloClient client)
      : super(name, description, client);

  MemberId get memberId {
    if (parameters.isEmpty) {
      usageException('Member Id was not given');
    }
    return MemberId(parameters.first);
  }
}
