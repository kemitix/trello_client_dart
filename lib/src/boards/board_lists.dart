import 'package:trello_client/src/cards/cards.dart';
import 'package:trello_client/src/http_client.dart';
import 'package:trello_client/src/lists/lists.dart';
import 'package:trello_client/src/misc.dart';

class BoardLists {
  final HttpClient _client;

  BoardLists(this._client);

  /**
   * Get Lists on a Board
   *
   * GET /1/boards/{id}/lists
   *
   * Get the Lists on a Board
   *
   * https://developer.atlassian.com/cloud/trello/rest/api-group-boards/#api-boards-id-lists-get
   */
  Future<List<TrelloList>> get(
    String boardId, {
    CardFilter cards = CardFilter.all,
    List<CardFields> card_fields = const [CardFields.all],
    ListFilter filter = ListFilter.all,
    List<ListFields> fields = const [ListFields.all],
  }) async =>
      ((await _client.get<List<dynamic>>(
                '/1/boards/${boardId}/lists',
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
