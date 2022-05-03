import 'package:args/command_runner.dart';

import '../../../trello_sdk.dart';
import 'cli.dart';

typedef Environment = Map<String, String>;

CommandRunner runner(CommandEnvironment commandEnvironment) {
  var runner = CommandRunner('trello', "A CLI for Trello");
  [
    MemberModule(commandEnvironment),
    BoardModule(commandEnvironment),
    ListModule(commandEnvironment),
    CardModule(commandEnvironment),
  ].forEach(runner.addCommand);
  return runner;
}
