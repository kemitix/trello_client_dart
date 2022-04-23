import 'dart:async';

import '../../../../trello_sdk.dart';
import 'member_module.dart';

class ListMemberBoardsCommand extends MemberCommand {
  ListMemberBoardsCommand(TrelloClient client)
      : super('list-boards', 'Get Boards that Member belongs to', client);

  final List<BoardFields> fields = [
    BoardFields.id,
    BoardFields.name,
    BoardFields.pinned,
    BoardFields.closed,
    BoardFields.starred,
    BoardFields.shortUrl,
  ];

  @override
  FutureOr<void> run() async =>
      (await client.member(memberId).getBoards(fields: fields))
          .map((boards) => tabulateObjects(boards, fields))
          .collapse(printOutput);
}
