import '../sdk.dart';

class Card {
  static Future<List<MemberId>> getMemberIds(
          CardId cardId, TrelloClient client) =>
      client
          .card(cardId)
          .get(fields: [CardFields.idMembers])
          .then((card) => card.idMembers)
          .then((members) =>
              members.map((id) => MemberId(id)).toList(growable: false));
}
