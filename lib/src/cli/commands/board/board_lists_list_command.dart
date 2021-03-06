import 'dart:async' show FutureOr;

import 'package:trello_client/trello_sdk.dart'
    show CollapsableEither, Either, Failure, ListFields, left;

import '../commands.dart' show CommandEnvironment, UpdateProperty;
import 'board_module.dart' show BoardCommand;

class ListListsCommand extends BoardCommand {
  ListListsCommand(CommandEnvironment commandEnvironment)
      : super('list-lists', 'Get Lists on a Board', commandEnvironment) {
    addFieldsOption(fields);
  }

  final List<ListFields> fields = [
    ListFields.id,
    ListFields.name,
    ListFields.pos,
    ListFields.closed,
    ListFields.subscribed,
  ];

  @override
  FutureOr<void> run() => Either.sequenceFuture(boardId.map((boardId) => client
          .board(boardId)
          .getLists(fields: getFields())
          .then((lists) => tabulateObjects(lists, getFields()))))
      .onError((Failure error, stackTrace) => left(error))
      .then((result) => result.collapse(printOutput));

  List<ListFields> getFields() =>
      getEnumFields(enumValues: ListFields.values, defaults: fields);

  @override
  List<UpdateProperty> get updateProperties => [];
}
