import 'dart:async';

import '../../../../trello_sdk.dart';
import 'card_module.dart';

class AddMemberToCardCommand extends CardCommand {
  AddMemberToCardCommand(TrelloClient client)
      : super('add-member', 'Add a Member to a Card', client);

  Either<Failure, MemberId> get memberId =>
      nextParameter('Member Id').map((id) => MemberId(id));

  @override
  FutureOr<void> run() => TaskEither.flatten(
          TaskEither.fromEither(map2either(cardId, memberId, _addMember)))
      .map((_) => "Added member")
      .run()
      .then((value) => value.collapse(printOutput));

  TaskEither<Failure, void> _addMember(CardId cardId, MemberId memberId) =>
      client
          .card(cardId)
          .get(fields: [CardFields.idMembers])
          .map((card) => card.idMembers)
          .filterOrElse(
            (idMembers) => !idMembers.contains(memberId.value),
            (idMembers) => AlreadyAppliedFailure(action: description),
          )
          .map((_) => client.card(cardId).addMember(memberId));
}
