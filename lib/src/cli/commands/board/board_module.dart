import 'package:args/command_runner.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../trello_sdk.dart';
import '../commands.dart';
import 'board_lists_list_command.dart';

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

  Either<Failure, BoardId> get boardId =>
      nextParameter('Board Id').map((id) => BoardId(id));
}
