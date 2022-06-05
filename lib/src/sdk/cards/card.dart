import '../client.dart' show TrelloClient;
import '../members/members.dart' show MemberId;
import 'card_models.dart' show CardFields, CardId;

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
