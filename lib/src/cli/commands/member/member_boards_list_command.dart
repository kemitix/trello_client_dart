import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../cli.dart';

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
  //TODO add fields override
  List<UpdateProperty> get updateProperties => [];
}
