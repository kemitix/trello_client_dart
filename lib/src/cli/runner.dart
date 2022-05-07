import 'package:args/command_runner.dart';

import 'cli.dart';

typedef Environment = Map<String, String>;

CommandRunner runner(CommandEnvironment commandEnvironment) {
  var runner =
      TrelloCommandRunner('trello', "A CLI for Trello", commandEnvironment);
  [
    MemberModule(commandEnvironment),
    BoardModule(commandEnvironment),
    ListModule(commandEnvironment),
    CardModule(commandEnvironment),
  ].forEach(runner.addCommand);
  return runner;
}

class TrelloCommandRunner extends CommandRunner {
  TrelloCommandRunner(
      String executableName, String description, this._commandEnvironment)
      : super(executableName, description);

  final CommandEnvironment _commandEnvironment;

  @override
  void printUsage() => _commandEnvironment.printer(usage);
}
