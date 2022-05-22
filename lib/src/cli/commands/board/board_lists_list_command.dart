import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../cli.dart';

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
  //TODO add fields override
  List<UpdateProperty> get updateProperties => [];
}
