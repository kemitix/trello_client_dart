import 'package:trello_client/src/http_client.dart';

import 'member_boards.dart';

class Members {
  final HttpClient _client;
  late final MemberBoards _memberBoards;

  Members(this._client) {
    _memberBoards = MemberBoards(_client);
  }

  MemberBoards get boards => _memberBoards;
}
