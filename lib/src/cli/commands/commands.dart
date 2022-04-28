import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tabular/tabular.dart';

import '../../../trello_sdk.dart';

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

  int _nextParameterIndex = 0;

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
        (failure) => print('ERROR: ${parent!.name} $name - $failure'),
        (output) => print(output),
      );
}
