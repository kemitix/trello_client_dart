import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:tabular/tabular.dart';

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
    print(tabular([
      ['username', member.username],
      ['email', member.email],
      ['full name', member.fullName],
      ['initials', member.initials],
      ['url', member.url],
      ['status', member.status],
      ['member type', member.memberType],
      ['confirmed', member.confirmed],
      ['Bio', member.bio],
    ], rowDividers: []));
  }
}
