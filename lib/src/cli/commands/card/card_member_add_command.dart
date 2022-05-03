import 'dart:async';

import '../../../../trello_sdk.dart';
import '../../cli.dart';

class AddMemberToCardCommand extends CardCommand {
  AddMemberToCardCommand(CommandEnvironment commandEnvironment)
      : super('add-member', 'Add a Member to a Card', commandEnvironment);

  Either<Failure, MemberId> get memberId =>
      nextParameter('Member Id').map((id) => MemberId(id));

  @override
  FutureOr<void> run() =>
      taskEitherFlatE(map2either(cardId, memberId, _addMember))
          .map((_) => "Added member")
          .run()
          .then((value) => value.collapse(printOutput));

  TaskEither<Failure, void> _addMember(CardId cardId, MemberId memberId) =>
      TaskEither.flatten(client
          .card(cardId)
          .get(fields: [CardFields.idMembers])
          .map((card) => card.idMembers)
          .filterOrElse(
            (idMembers) => !idMembers.contains(memberId.value),
            (idMembers) => AlreadyAppliedFailure(action: description),
          )
          .map((_) => client.card(cardId).addMember(memberId)));
}
