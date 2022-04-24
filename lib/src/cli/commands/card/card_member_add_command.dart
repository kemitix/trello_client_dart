import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../trello_sdk.dart';
import 'card_module.dart';

class AddMemberToCardCommand extends CardCommand {
  AddMemberToCardCommand(TrelloClient client)
      : super('add-member', 'Add a Member to a Card', client);

  Either<Failure, MemberId> get memberId =>
      nextParameter('Member Id').map((id) => MemberId(id));

  @override
  FutureOr<void> run() async =>
      (await Either.map2(cardId, memberId, _addMember).unwrapFuture())
          .map((_) => "Added member")
          .collapse(printOutput);

  Future<Either<Failure, void>> _addMember(
          CardId cardId, MemberId memberId) async =>
      ((await client.card(cardId).get(fields: [CardFields.idMembers]))
              .map((card) => card.idMembers)
              .where((idMembers) => !idMembers.contains(memberId.value),
                  () => AlreadyAppliedFailure(action: description))
              .map((_) => (client.card(cardId).addMember(memberId))))
          .unwrapFuture();
}
