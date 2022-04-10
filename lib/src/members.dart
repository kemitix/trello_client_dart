import 'package:trello_client/src/client.dart';
import 'package:trello_client/src/misc.dart';
import 'package:trello_client/src/models/models.dart';

class Members {
  final TrelloClient _client;

  Members(this._client);

  // Get Boards that Member belongs to
  // https://developer.atlassian.com/cloud/trello/rest/api-group-members/#api-members-id-boards-get
  Future<List<Board>> getMemberBoards({
    MemberBoardFilter filter = MemberBoardFilter.all,
    List<BoardFields>? fields,
  }) async =>
      ((await _client.get<List<dynamic>>(
                '/1/members/${_client.username}/boards',
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
