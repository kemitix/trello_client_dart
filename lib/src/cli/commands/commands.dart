import 'package:args/command_runner.dart';
import 'package:trello_sdk/trello_sdk.dart';

export 'member_command.dart';

abstract class TrelloCommand extends Command {
  final String _name;
  final String _description;
  final TrelloClient _client;

  TrelloCommand(
    this._name,
    this._description,
    this._client,
  );

  @override
  String get name => _name;
  @override
  String get description => _description;
  TrelloClient get client => _client;

  List<String> get parameters => argResults!.rest;
}
