import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../cli.dart';

class RemoveMemberToCardCommand extends CardCommand {
  RemoveMemberToCardCommand(CommandEnvironment commandEnvironment)
      : super(
            'remove-member', 'Remove a Member from a Card', commandEnvironment);

  Either<Failure, MemberId> get memberId =>
      nextParameter('Member Id').map((id) => MemberId(id));

  @override
  FutureOr<void> run() =>
      taskEitherFlatE(map2either(cardId, memberId, _removeMember))
          .map((_) => "Removed member")
          .run()
          .then((value) => value.collapse(printOutput));

  TaskEither<Failure, void> _removeMember(CardId cardId, MemberId memberId) =>
      TaskEither.flatten(client
          .card(cardId)
          .get(fields: [CardFields.idMembers])
          .map((card) => card.idMembers)
          .filterOrElse(
            (idMembers) => idMembers.contains(memberId.value),
            (idMembers) => AlreadyAppliedFailure(action: description),
          )
          .map((_) => client.card(cardId).removeMember(memberId)));
}
