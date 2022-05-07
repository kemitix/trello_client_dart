import 'package:args/command_runner.dart';

import '../../../../trello_sdk.dart';
import '../commands.dart';
import 'board_lists_list_command.dart';

class BoardModule extends TrelloModule {
  @override
  final String name = 'board';
  @override
  final String description = 'Trello Boards';

  BoardModule(CommandEnvironment commandEnvironment)
      : super(commandEnvironment) {
    [ListListsCommand(commandEnvironment)].forEach(addSubcommand);
  }
}

abstract class BoardCommand extends TrelloCommand {
  BoardCommand(
      String name, String description, CommandEnvironment commandEnvironment)
      : super(name, description, commandEnvironment);

  Either<Failure, BoardId> get boardId =>
      nextParameter('Board Id').map((id) => BoardId(id));
}
