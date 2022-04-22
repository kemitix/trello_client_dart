import 'dart:async';

import 'package:args/command_runner.dart';

import '../../../trello_sdk.dart';
import 'commands.dart';

class MemberModule extends Command {
  @override
  final String name = 'member';
  @override
  final String description = 'Trello Members (users)';

  MemberModule(TrelloClient client) {
    [
      GetMemberCommand(client),
      ListMemberBoardsCommand(client),
    ].forEach(addSubcommand);
  }
}

abstract class MemberCommand extends TrelloCommand {
  MemberCommand(String name, String description, TrelloClient client)
      : super(name, description, client);

  MemberId get memberId {
    if (parameters.isEmpty) {
      usageException('Member Id was not given');
    }
    return MemberId(parameters.first);
  }
}

class GetMemberCommand extends MemberCommand {
  GetMemberCommand(TrelloClient client) : super('get', 'Get a Member', client);

  final List<MemberFields> fields = [
    MemberFields.username,
    MemberFields.email,
    MemberFields.fullName,
    MemberFields.initials,
    MemberFields.url,
    MemberFields.status,
    MemberFields.memberType,
    MemberFields.confirmed,
    MemberFields.bio,
  ];

  @override
  FutureOr<void> run() async {
    (await client.member(memberId).get())
        .map((member) => tabulateObject(member, fields))
        .fold(
          (failure) => print(failure),
          (table) => print(table),
        );
  }
}

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
  FutureOr<void> run() async {
    (await client.member(memberId).getBoards(fields: fields))
        .map((boards) => tabulateObjects(boards, fields))
        .fold(
          (failure) => print(failure),
          (table) => print(table),
        );
  }
}
