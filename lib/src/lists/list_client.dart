import '../cards/cards.dart';
import '../http_client.dart';
import 'lists.dart';

class ListClient {
  final HttpClient _client;
  final ListId _id;

  ListClient(this._client, this._id);

  /// Get Cards in a List
  ///
  /// GET /1/lists/{id}/cards
  ///
  /// List the cards in a list
  ///
  /// https://developer.atlassian.com/cloud/trello/rest/api-group-lists/#api-lists-id-cards-get
  Future<List<Card>> getCards({List<CardFields>? fields}) async =>
      ((await _client.get<List<dynamic>>(
                '/1/lists/${_id}/cards',
                queryParameters: {},
              ))
                  .data ??
              [])
          .map((item) => Card(item, fields ?? [CardFields.all]))
          .toList(growable: false);
}
