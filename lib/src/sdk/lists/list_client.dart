import '../../../trello_sdk.dart';
import '../http_client.dart';
import '../query_options.dart';

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
  Future<List<TrelloCard>> getCards({List<CardFields>? fields}) => _client
      .get<List<dynamic>>(QueryOptions(
        path: '/1/lists/$_id/cards',
      ))
      .then((response) => response.data ?? [])
      .then((items) => items
          .map((item) => TrelloCard(item, fields ?? [CardFields.all]))
          .toList(growable: false));
}
