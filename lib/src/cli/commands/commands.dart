import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:tabular/tabular.dart';

import '../../../trello_sdk.dart';

class CommandEnvironment {
  CommandEnvironment(this._client, this._printer);

  final TrelloClient _client;
  final void Function(Object s) _printer;

  TrelloClient get client => _client;
  void Function(Object s) get printer => _printer;
}

abstract class TrelloModule extends Command {
  final CommandEnvironment _commandEnvironment;

  TrelloModule(this._commandEnvironment);

  CommandEnvironment get e => _commandEnvironment;

  @override
  void printUsage() => e.printer(usage);
}

abstract class TrelloCommand extends Command {
  final String _name;
  final String _description;
  final CommandEnvironment _commandEnvironment;

  CommandEnvironment get e => _commandEnvironment;

  TrelloCommand(
    this._name,
    this._description,
    this._commandEnvironment,
  );

  @override
  String get name => _name;

  @override
  String get description => _description;

  TrelloClient get client => _commandEnvironment.client;

  List<String> get parameters => argResults!.rest;

  int _nextParameterIndex = 0;

  @override
  void printUsage() => e.printer(usage);

  Either<Failure, String> nextParameter(String description) =>
      parameters.length <= _nextParameterIndex
          ? Left(UsageFailure(usage: '$description not given'))
          : Right(parameters[_nextParameterIndex++]);

  String tabulateObject<T extends Enum>(
    TrelloObject<T> object,
    List<T> fields,
  ) =>
      tabular(
          fields.map((field) => [field.name, object.getValue(field)]).toList(),
          rowDividers: []);

  String tabulateObjects<T extends Enum>(
    List<TrelloObject<T>> objects,
    List<T> fields,
  ) =>
      tabular([
        fields.map((field) => field.name).toList(),
        ...objects.map(objectFieldValuesAsStringList(fields))
      ]);

  List<String> Function(TrelloObject<T>)
      objectFieldValuesAsStringList<T extends Enum>(List<T> fields) =>
          (object) => fields.map(fieldValueAsString(object)).toList();

  String Function(T) fieldValueAsString<T extends Enum>(
          TrelloObject<T> object) =>
      (field) => object.getValue(field).toString();

  FutureOr<void> printOutput(Either<Failure, String> either) => either.fold(
        (failure) => e.printer('ERROR: ${parent!.name} $name - $failure'),
        (output) => e.printer(output),
      );
}
