import 'package:trello_client/src/client.dart';
import 'package:trello_client/src/lists.dart';
import 'package:trello_client/src/misc.dart';

class Boards {
  final TrelloClient _client;

  Boards(this._client);

  // Get Lists on a Board
  // https://developer.atlassian.com/cloud/trello/rest/api-group-boards/#api-boards-id-lists-get
  Future<List<TrelloList>> getBoardLists(
          {required String boardId,
          BoardListFilter filter = BoardListFilter.all,
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

enum ListFields {
  all,
  id,
  name,
  //TODO more
}

enum BoardListFilter {
  all,
  closed,
  none,
  open,
}
