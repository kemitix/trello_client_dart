import 'package:args/command_runner.dart';

import '../../../../trello_sdk.dart';
import '../commands.dart';
import 'list_cards_list_command.dart';

class ListModule extends Command {
  @override
  final String name = 'list';
  @override
  final String description = 'Trello Lists';

  ListModule(CommandEnvironment commandEnvironment) {
    [ListCardsCommand(commandEnvironment)].forEach(addSubcommand);
  }
}

abstract class ListCommand extends TrelloCommand {
  ListCommand(String name, String description, CommandEnvironment commandEnvironment)
      : super(name, description, commandEnvironment);

  Either<Failure, ListId> get listId =>
      nextParameter('List Id').map((id) => ListId(id));
}
