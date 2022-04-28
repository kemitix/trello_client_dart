import '../../../trello_sdk.dart';
import '../http_client.dart';

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
  TaskEither<Failure, List<TrelloList>> getLists({
    CardFilter cards = CardFilter.all,
    List<CardFields> card_fields = const [CardFields.all],
    ListFilter filter = ListFilter.all,
    List<ListFields> fields = const [ListFields.all],
  }) =>
      _client
          .get<List<dynamic>>(
            '/1/boards/${_id}/lists',
            queryParameters: {
              'cards': cards.name,
              'card_fields': asCsv(card_fields),
              'filter': filter.name,
              'fields': asCsv(fields),
            },
          )
          .mapLeft((failure) => failure.withContext({'boardId': _id.value}))
          .map((response) => response.data ?? [])
          .map((items) => items
              .map((item) => TrelloList(item, fields))
              .toList(growable: false));
}
