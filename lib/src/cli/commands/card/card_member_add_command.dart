import 'dart:async' show Future, FutureOr;

import 'package:trello_client/trello_sdk.dart'
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

class AddMemberToCardCommand extends CardCommand {
  AddMemberToCardCommand(CommandEnvironment commandEnvironment)
      : super('add-member', 'Add a Member to a Card', commandEnvironment);

  Either<Failure, MemberId> get memberId =>
      nextParameter('Member Id').map((id) => MemberId(id));

  @override
  FutureOr<void> run() =>
      Either.sequenceFuture(map2either(cardId, memberId, _addMember))
          .onError((Failure error, stackTrace) => left(error))
          .then((result) =>
              result.map((_) => "Added member").collapse(printOutput));

  Future<HttpResponse<void>> _addMember(CardId cardId, MemberId memberId) =>
      _verifyIsNotAMember(cardId, memberId)
          .then((_) => client.card(cardId).addMember(memberId));

  Future<void> _verifyIsNotAMember(CardId cardId, MemberId memberId) =>
      Card.getMemberIds(cardId, client)
          .then((idMembers) => idMembers.contains(memberId))
          .then(
        (isMember) {
          if (isMember) {
            return Future.error(AlreadyAppliedFailure(action: description));
          }
        },
      );

  @override
  List<UpdateProperty> get updateProperties => [];
}
