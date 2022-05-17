import 'dart:async';

import 'package:trello_sdk/src/sdk/http_client.dart';

import '../../../../trello_sdk.dart';
import '../../../sdk/cards/card.dart';
import '../../cli.dart';

class AddMemberToCardCommand extends CardCommand {
  AddMemberToCardCommand(CommandEnvironment commandEnvironment)
      : super('add-member', 'Add a Member to a Card', commandEnvironment);

  Either<Failure, MemberId> get memberId =>
      nextParameter('Member Id').map((id) => MemberId(id));

  @override
  FutureOr<void> run() async =>
      (await Either.sequenceFuture(map2either(cardId, memberId, _addMember)
              .map((a) async => (await a).map((_) => "Added member"))))
          .flatMap(id)
          .collapse(printOutput);

  Future<Either<Failure, HttpResponse<void>>> _addMember(
          CardId cardId, MemberId memberId) async =>
      (await Either.sequenceFuture((await _verifyIsNotAMember(cardId, memberId))
              .map((isValid) => client.card(cardId).addMember(memberId))))
          .flatMap(id);

  Future<Either<Failure, List<MemberId>>> _verifyIsNotAMember(
          CardId cardId, MemberId memberId) async =>
      (await Card.getMemberIds(cardId, client)).filter(
        (idMembers) => !idMembers.contains(memberId),
        () => AlreadyAppliedFailure(action: description),
      );
}
