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
  FutureOr<void> run() async =>
      (await Either.sequenceFuture(map2either(cardId, memberId, _removeMember)
              .map((a) async => (await a).map((_) => "Removed member"))))
          .flatMap(id)
          .collapse(printOutput);

  Future<Either<Failure, HttpResponse<void>>> _removeMember(
          CardId cardId, MemberId memberId) async =>
      (await Either.sequenceFuture((await _verifyIsAMember(cardId, memberId))
              .map((isValid) => client.card(cardId).removeMember(memberId))))
          .flatMap(id);

  Future<Either<Failure, List<MemberId>>> _verifyIsAMember(
          CardId cardId, MemberId memberId) async =>
      (await Card.getMemberIds(cardId, client)).filter(
        (idMembers) => idMembers.contains(memberId),
        () => AlreadyAppliedFailure(action: description),
      );
}
