import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../../sdk/cards/card.dart';
import '../../cli.dart';

class AddMemberToCardCommand extends CardCommand {
  AddMemberToCardCommand(CommandEnvironment commandEnvironment)
      : super('add-member', 'Add a Member to a Card', commandEnvironment);

  Either<Failure, MemberId> get memberId =>
      nextParameter('Member Id').map((id) => MemberId(id));

  @override
  FutureOr<void> run() => TaskEither.map2Either(cardId, memberId, _addMember)
      .map((_) => "Added member")
      .run()
      .then((result) => result.collapse(printOutput));

  TaskEither<Failure, void> _addMember(CardId cardId, MemberId memberId) =>
      TaskEither.flatten(_verifyIsNotAMember(cardId, memberId)
          .map((_) => client.card(cardId).addMember(memberId)));

  TaskEither<Failure, List<MemberId>> _verifyIsNotAMember(
          CardId cardId, MemberId memberId) =>
      Card.getMemberIds(cardId, client).filterOrElse(
        (idMembers) => !idMembers.contains(memberId),
        (idMembers) => AlreadyAppliedFailure(action: description),
      );
}
