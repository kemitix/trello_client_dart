import 'dart:async' show Future, FutureOr;

import 'package:trello_sdk/trello_sdk.dart'
    show
        AlreadyAppliedFailure,
        Card,
        CardId,
        CollapsableEither,
        Either,
        Failure,
        HttpResponse,
        MemberId,
        left,
        map2either;

import '../commands.dart' show CommandEnvironment, UpdateProperty;
import 'card_module.dart' show CardCommand;

class RemoveMemberFromCardCommand extends CardCommand {
  RemoveMemberFromCardCommand(CommandEnvironment commandEnvironment)
      : super(
            'remove-member', 'Remove a Member from a Card', commandEnvironment);

  Either<Failure, MemberId> get memberId =>
      nextParameter('Member Id').map((id) => MemberId(id));

  @override
  FutureOr<void> run() =>
      Either.sequenceFuture(map2either(cardId, memberId, _removeMember))
          .onError((Failure error, stackTrace) => left(error))
          .then((result) =>
              result.map((_) => "Removed member").collapse(printOutput));

  Future<HttpResponse<void>> _removeMember(CardId cardId, MemberId memberId) =>
      _verifyIsAMember(cardId, memberId)
          .then((memberId) => client.card(cardId).removeMember(memberId));

  Future<MemberId> _verifyIsAMember(CardId cardId, MemberId memberId) =>
      Card.getMemberIds(cardId, client).then((idMembers) {
        return idMembers.contains(memberId);
      }).then((isMember) {
        if (!isMember) {
          return Future.error(AlreadyAppliedFailure(action: description));
        }
        return Future.value(memberId);
      });

  @override
  List<UpdateProperty> get updateProperties => [];
}
