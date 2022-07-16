import 'dart:async' show FutureOr;

import 'package:trello_client/trello_sdk.dart'
    show BoardFields, CollapsableEither, Either, Failure, left;

import '../commands.dart' show CommandEnvironment, UpdateProperty;
import 'member_module.dart' show MemberCommand;

class ListMemberBoardsCommand extends MemberCommand {
  ListMemberBoardsCommand(CommandEnvironment commandEnvironment)
      : super('list-boards', 'Get Boards that Member belongs to',
            commandEnvironment) {
    addFieldsOption(fields);
  }

  final List<BoardFields> fields = [
    BoardFields.id,
    BoardFields.name,
    BoardFields.pinned,
    BoardFields.closed,
    BoardFields.starred,
    BoardFields.shortUrl,
  ];

  @override
  FutureOr<void> run() => Either.sequenceFuture(memberId.map(
          (memberId) => client.member(memberId).getBoards(fields: getFields())))
      .onError((Failure error, stackTrace) => left(error))
      .then((result) => result
          .map((boards) => tabulateObjects(boards, getFields()))
          .collapse(printOutput));

  List<BoardFields> getFields() =>
      getEnumFields(enumValues: BoardFields.values, defaults: fields);

  @override
  List<UpdateProperty> get updateProperties => [];
}
