import 'package:args/command_runner.dart';

import '../../../trello_sdk.dart';
import 'cli.dart';

typedef Environment = Map<String, String>;

CommandRunner runner(TrelloClient client) {
  var runner = CommandRunner('trello', "A CLI for Trello");
  [
    MemberModule(client),
    BoardModule(client),
    ListModule(client),
    CardModule(client),
  ].forEach(runner.addCommand);
  return runner;
}
