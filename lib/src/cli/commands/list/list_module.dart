import 'package:trello_client/trello_sdk.dart' show Either, Failure, ListId;

import '../commands.dart' show CommandEnvironment, TrelloCommand, TrelloModule;
import 'list_cards_list_command.dart' show ListCardsCommand;

class ListModule extends TrelloModule {
  @override
  final String name = 'list';
  @override
  final String description = 'Trello Lists';

  ListModule(CommandEnvironment commandEnvironment)
      : super(commandEnvironment) {
    [ListCardsCommand(commandEnvironment)].forEach(addSubcommand);
  }
}

abstract class ListCommand extends TrelloCommand {
  ListCommand(super.name, super.description, super.commandEnvironment);

  Either<Failure, ListId> get listId =>
      nextParameter('List Id').map((id) => ListId(id));
}
