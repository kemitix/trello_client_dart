import 'package:args/command_runner.dart';
import 'package:trello_sdk/trello_sdk.dart';

export 'member_command.dart';

abstract class TrelloCommand extends Command {
  final TrelloClient client;

  TrelloCommand(this.client);
}
