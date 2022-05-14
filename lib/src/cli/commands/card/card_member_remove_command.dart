import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../../sdk/cards/card.dart';
import '../../cli.dart';

class RemoveMemberFromCardCommand extends CardCommand {
  RemoveMemberFromCardCommand(CommandEnvironment commandEnvironment)
      : super(
            'remove-member', 'Remove a Member from a Card', commandEnvironment);

  Either<Failure, MemberId> get memberId =>
      nextParameter('Member Id').map((id) => MemberId(id));

  @override
  FutureOr<void> run() => TaskEither.map2Either(cardId, memberId, _removeMember)
      .map((_) => "Removed member")
      .run()
      .then((result) => result.collapse(printOutput));

  TaskEither<Failure, void> _removeMember(CardId cardId, MemberId memberId) =>
      TaskEither.flatten(_verifyIsAMember(cardId, memberId)
          .map((_) => client.card(cardId).removeMember(memberId)));

  TaskEither<Failure, List<MemberId>> _verifyIsAMember(
          CardId cardId, MemberId memberId) =>
      Card.getMemberIds(cardId, client).filterOrElse(
        (idMembers) => idMembers.contains(memberId),
        (idMembers) => AlreadyAppliedFailure(action: description),
      );
}
