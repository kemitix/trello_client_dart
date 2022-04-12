import '../boards/boards.dart';
import '../http_client.dart';
import '../misc.dart';

class MemberBoards {
  final HttpClient _client;
  final String _id;

  MemberBoards(this._client, this._id);

  /**
   * Get Boards that Member belongs to
   *
   * https://developer.atlassian.com/cloud/trello/rest/api-group-members/#api-members-id-boards-get
   */
  Future<List<Board>> get({
    MemberBoardFilter filter = MemberBoardFilter.all,
    List<BoardFields>? fields,
  }) async =>
      ((await _client.get<List<dynamic>>(
                '/1/members/${this._id}/boards',
                queryParameters: {
                  'filter': filter.name,
                  'fields': listEnumToCsv(fields ?? [BoardFields.all])
                },
              ))
                  .data ??
              [])
          .map((item) => Board(item, fields ?? [BoardFields.all]))
          .toList(growable: false);
}

enum MemberBoardFilter {
  all,
  closed,
  members,
  open,
  organization,
  public,
  starred,
}
