import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../cli.dart';

class ListMemberBoardsCommand extends MemberCommand {
  ListMemberBoardsCommand(CommandEnvironment commandEnvironment)
      : super('list-boards', 'Get Boards that Member belongs to',
            commandEnvironment);

  final List<BoardFields> fields = [
    BoardFields.id,
    BoardFields.name,
    BoardFields.pinned,
    BoardFields.closed,
    BoardFields.starred,
    BoardFields.shortUrl,
  ];

  @override
  FutureOr<void> run() => Either.sequenceFuture(memberId
          .map((memberId) => client.member(memberId).getBoards(fields: fields)))
      .then((result) => result
          .map((boards) => tabulateObjects(boards, fields))
          .collapse(printOutput));
}
