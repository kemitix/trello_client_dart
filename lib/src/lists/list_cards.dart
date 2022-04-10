import 'package:trello_client/src/cards/cards.dart';
import 'package:trello_client/src/http_client.dart';

class ListCards {
  final HttpClient _client;

  ListCards(this._client);

  // Get Cards in a List
  // https://developer.atlassian.com/cloud/trello/rest/api-group-lists/#api-lists-id-cards-get
  Future<List<Card>> get(String listId, {List<CardFields>? fields}) async =>
      ((await _client.get<List<dynamic>>(
                '/1/lists/${listId}/cards',
                queryParameters: {},
              ))
                  .data ??
              [])
          .map((item) => Card(item, fields ?? [CardFields.all]))
          .toList(growable: false);
}
