import 'dart:async';

import 'package:args/command_runner.dart';

import '../../../trello_sdk.dart';
import '../cli.dart';

class MemberCommand extends Command {
  @override
  final String name = 'member';
  @override
  final String description = 'Trello Members (users)';

  MemberCommand(TrelloClient client) {
    [GetMemberCommand(client)].forEach(addSubcommand);
  }
}

class GetMemberCommand extends TrelloCommand {
  GetMemberCommand(TrelloClient client) : super('get', 'Get a member', client);

  final String errorIdMissing = 'Member Id was not given';

  @override
  FutureOr<void> run() async {
    if (parameters.isEmpty) throw UsageException(errorIdMissing, usage);
    MemberId id = MemberId(parameters.first);
    Member member = await client.member(id).get();
    print(member.url);
  }
}
