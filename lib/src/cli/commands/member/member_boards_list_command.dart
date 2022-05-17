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
  FutureOr<void> run() async => (await Either.sequenceFuture(memberId
          .map((MemberId memberId) => client.member(memberId))
          .map((client) => client.getBoards(fields: fields))))
      .flatMap(id)
      .map((board) => tabulateObjects(board, fields))
      .collapse(printOutput);
}
