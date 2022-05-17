import '../sdk.dart';

class Card {
  static Future<Either<Failure, List<MemberId>>> getMemberIds(
          CardId cardId, TrelloClient client) async =>
      (await client.card(cardId).get(fields: [CardFields.idMembers]))
          .map((card) => card.idMembers)
          .map((members) =>
              members.map((id) => MemberId(id)).toList(growable: false));
}
