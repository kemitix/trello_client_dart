import 'package:trello_client/src/http_client.dart';
import 'package:trello_client/src/lists/lists.dart';
import 'package:trello_client/src/misc.dart';

class BoardLists {
  final HttpClient _client;

  BoardLists(this._client);

  /**
   * Get Lists on a Board
   *
   * https://developer.atlassian.com/cloud/trello/rest/api-group-boards/#api-boards-id-lists-get
   */
  Future<List<TrelloList>> get(String boardId,
          {BoardListFilter filter = BoardListFilter.all,
          List<ListFields>? fields}) async =>
      ((await _client.get<List<dynamic>>(
                '/1/boards/${boardId}/lists',
                queryParameters: {
                  'cards': 'all',
                  'card_fields': 'all',
                  'filter': filter.name,
                  'fields': listEnumToCsv(fields ?? [ListFields.all]),
                },
              ))
                  .data ??
              [])
          .map((item) => TrelloList(item, fields ?? [ListFields.all]))
          .toList(growable: false);
}

enum BoardListFilter {
  all,
  closed,
  none,
  open,
}
