import 'dart:async';

import 'package:args/command_runner.dart';

import '../../../trello_sdk.dart';
import '../cli.dart';

class MemberCommand extends TrelloCommand {
  @override
  final String name = 'member';
  @override
  final String description = 'Trello Members (users)';

  MemberCommand(TrelloClient client) : super(client) {
    addSubcommand(GetMemberCommand(client));
  }
}

class GetMemberCommand extends TrelloCommand {
  @override
  final String name = 'get';
  @override
  final String description = 'Get a member';

  GetMemberCommand(TrelloClient client) : super(client);

  @override
  FutureOr<void> run() async {
    if (argResults!.rest.isEmpty) {
      throw UsageException('Member Id not given', usage);
    }
    MemberId id = MemberId(argResults!.rest.first);
    Member member = await client.member(id).get();
    print(member.url);
  }
}
