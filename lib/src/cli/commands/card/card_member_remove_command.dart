import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../../sdk/cards/card.dart';
import '../../../sdk/http_client.dart';
import '../../cli.dart';

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
