import '../cards/cards.dart';
import '../http_client.dart';
import '../lists/lists.dart';
import '../misc.dart';

class BoardClient {
  final HttpClient _client;
  final String _id;

  BoardClient(this._client, this._id);

  /// Get Lists on a Board
  ///
  /// GET /1/boards/{id}/lists
  ///
  /// Get the Lists on a Board
  ///
  /// https://developer.atlassian.com/cloud/trello/rest/api-group-boards/#api-boards-id-lists-get
  Future<List<TrelloList>> getLists({
    CardFilter cards = CardFilter.all,
    List<CardFields> card_fields = const [CardFields.all],
    ListFilter filter = ListFilter.all,
    List<ListFields> fields = const [ListFields.all],
  }) async =>
      ((await _client.get<List<dynamic>>(
                '/1/boards/${_id}/lists',
                queryParameters: {
                  'cards': cards.name,
                  'card_fields': listEnumToCsv(card_fields),
                  'filter': filter.name,
                  'fields': listEnumToCsv(fields),
                },
              ))
                  .data ??
              [])
          .map((item) => TrelloList(item, fields))
          .toList(growable: false);
}
