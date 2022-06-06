import '../cards/cards.dart' show CardFields;
import '../errors.dart' show Failure;
import '../http_client.dart' show HttpClient;
import '../lists/lists.dart' show ListFields, TrelloList;
import '../misc.dart' show asCsv;
import '../query_options.dart' show QueryOptions;
import 'board_id.dart' show BoardId;
import 'card_filter.dart' show CardFilter;
import 'list_filter.dart';

class BoardClient {
  final HttpClient _client;
  final BoardId _id;

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
    List<CardFields> cardFields = const [CardFields.all],
    ListFilter filter = ListFilter.all,
    List<ListFields> fields = const [ListFields.all],
  }) =>
      _client
          .get<List<dynamic>>(QueryOptions(
            path: '/1/boards/$_id/lists',
            queryParameters: {
              'cards': cards.name,
              'card_fields': asCsv(cardFields),
              'filter': filter.name,
              'fields': asCsv(fields),
            },
          ))
          .onError((Failure error, stackTrace) =>
              Future.error(error.withContext({'boardId': _id.value})))
          .then((response) => response.data ?? [])
          .then((items) => items
              .map((item) => TrelloList(item, fields))
              .toList(growable: false));
}
