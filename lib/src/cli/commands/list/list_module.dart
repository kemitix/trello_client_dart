import 'package:args/command_runner.dart';

import '../../../../trello_sdk.dart';
import '../commands.dart';
import 'list_cards_list_command.dart';

class ListModule extends Command {
  @override
  final String name = 'list';
  @override
  final String description = 'Trello Lists';

  ListModule(TrelloClient client) {
    [ListCardsCommand(client)].forEach(addSubcommand);
  }
}

abstract class ListCommand extends TrelloCommand {
  ListCommand(String name, String description, TrelloClient client)
      : super(name, description, client);

  Either<Failure, ListId> get listId =>
      nextParameter('List Id').map((id) => ListId(id));
}
