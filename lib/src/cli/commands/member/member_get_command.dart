import 'dart:async';

import '../../../../trello_sdk.dart';
import 'member_module.dart';

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
    printOutput((await client.member(memberId).get())
        .map((member) => tabulateObject(member, fields)));
  }
}
