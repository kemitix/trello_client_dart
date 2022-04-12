import '../../trello_client.dart';
import '../boards/boards.dart';
import '../http_client.dart';
import '../misc.dart';

class MemberClient {
  final HttpClient _client;
  final MemberId _id;

  MemberClient(this._client, this._id);

  /// Get Boards that Member belongs to
  ///
  /// GET /1/members/{id}/boards
  ///
  /// Lists the boards that the user is a member of.
  ///
  /// https://developer.atlassian.com/cloud/trello/rest/api-group-members/#api-members-id-boards-get
  Future<List<Board>> getBoards({
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

class MemberId extends StringId {
  MemberId(id) : super(id);
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
