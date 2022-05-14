import '../sdk.dart';

class Card {
  static TaskEither<Failure, List<MemberId>> getMemberIds(
          CardId cardId, TrelloClient client) =>
      client
          .card(cardId)
          .get(fields: [CardFields.idMembers])
          .map((card) => card.idMembers)
          .map((members) =>
              members.map((id) => MemberId(id)).toList(growable: false));
}
