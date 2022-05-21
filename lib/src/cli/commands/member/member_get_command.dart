import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../cli.dart';

class GetMemberCommand extends MemberCommand {
  GetMemberCommand(CommandEnvironment commandEnvironment)
      : super('get', 'Get a Member', commandEnvironment);

  final List<MemberFields> fields = [
    MemberFields.id,
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
  FutureOr<void> run() => Either.sequenceFuture(memberId
          .map((memberId) => client.member(memberId).get(fields: fields)))
      .then((result) => result
          .map((member) => tabulateObject(member, fields))
          .collapse(printOutput));
}
