import 'package:args/command_runner.dart';
import 'package:tabular/tabular.dart';

import '../../../trello_sdk.dart';

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

  String tabulateObject<T extends Enum>(
    TrelloObject<T> object,
    List<T> fields,
  ) {
    return tabular(
        fields.map((field) => [field.name, object.getValue(field)]).toList(),
        rowDividers: []);
  }

  String tabulateObjects<T extends Enum>(
    List<TrelloObject<T>> objects,
    List<T> fields,
  ) {
    List<List<String>> data = [
      fields.map((field) => field.name).toList(),
      ...objects.map(objectFieldValuesAsStringList(fields))
    ];
    return tabular(data);
  }

  List<String> Function(TrelloObject<T>)
      objectFieldValuesAsStringList<T extends Enum>(List<T> fields) =>
          (object) => fields.map(fieldValueAsString(object)).toList();

  String Function(T) fieldValueAsString<T extends Enum>(
          TrelloObject<T> object) =>
      (field) => object.getValue(field).toString();
}
