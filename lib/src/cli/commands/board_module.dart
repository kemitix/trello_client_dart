import 'package:args/command_runner.dart';

import '../../../trello_sdk.dart';
import 'board_lists_list_command.dart';
import 'commands.dart';

class BoardModule extends Command {
  @override
  final String name = 'board';
  @override
  final String description = 'Trello Boards';

  BoardModule(TrelloClient client) {
    [ListListsCommand(client)].forEach(addSubcommand);
  }
}

abstract class BoardCommand extends TrelloCommand {
  BoardCommand(String name, String description, TrelloClient client)
      : super(name, description, client);

  BoardId get boardId {
    if (parameters.isEmpty) {
      usageException('Board Id was nto given');
    }
    return BoardId(parameters.first);
  }
}
