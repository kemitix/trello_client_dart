import '../../../../trello_sdk.dart';
import '../commands.dart';
import 'list_cards_list_command.dart';

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
