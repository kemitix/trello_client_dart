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
      Either.sequenceFuture(map2either(cardId, memberId, _removeMember)).then(
          (result) =>
              result.map((_) => "Removed member").collapse(printOutput));

  Future<HttpResponse<void>> _removeMember(CardId cardId, MemberId memberId) =>
      _verifyIsAMember(cardId, memberId)
          .then((_) => client.card(cardId).removeMember(memberId));

  Future<void> _verifyIsAMember(CardId cardId, MemberId memberId) =>
      Card.getMemberIds(cardId, client)
          .then((idMembers) => !idMembers.contains(memberId))
          .then((isNotMember) {
        if (isNotMember) {
          return Future.error(AlreadyAppliedFailure(action: description));
        }
      });
}
