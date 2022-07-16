import 'dart:async' show FutureOr;

import 'package:trello_client/trello_sdk.dart'
    show CollapsableEither, Either, Failure, MemberFields, left;

import '../commands.dart' show CommandEnvironment, UpdateProperty;
import 'member_module.dart' show MemberCommand;

class GetMemberCommand extends MemberCommand {
  GetMemberCommand(CommandEnvironment commandEnvironment)
      : super('get', 'Get a Member', commandEnvironment) {
    addFieldsOption(fields);
  }

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
          .map((memberId) => client.member(memberId).get(fields: getFields())))
      .onError((Failure error, stackTrace) => left(error))
      .then((result) => result
          .map((member) => tabulateObject(member, getFields()))
          .collapse(printOutput));

  List<MemberFields> getFields() =>
      getEnumFields(enumValues: MemberFields.values, defaults: fields);

  @override
  List<UpdateProperty> get updateProperties => [];
}
