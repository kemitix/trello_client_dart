import 'package:trello_client/src/http_client.dart';
import 'package:trello_client/src/models/card_models.dart';

class Lists {
  final HttpClient _client;

  Lists(this._client);

  // Get Cards in a List
  // https://developer.atlassian.com/cloud/trello/rest/api-group-lists/#api-lists-id-cards-get
  Future<List<Card>> getCards(
          {required String listId, List<CardFields>? fields}) async =>
      ((await _client.get<List<dynamic>>(
                '/1/lists/${listId}/cards',
                queryParameters: {},
              ))
                  .data ??
              [])
          .map((item) => Card(item, fields ?? [CardFields.all]))
          .toList(growable: false);
}
