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
  FutureOr<void> run() => TaskEither.map1Either(
          memberId,
          (MemberId memberId) =>
              client.member(memberId).getBoards(fields: fields))
      .map((board) => tabulateObjects(board, fields))
      .run()
      .then((value) => value.collapse(printOutput));
}
