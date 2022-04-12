import 'package:trello_client/src/http_client.dart';

import 'member_boards.dart';

class MemberClient {
  final HttpClient _client;
  final String _id;
  late final MemberBoards _memberBoards;

  MemberClient(this._client, this._id) {
    _memberBoards = MemberBoards(_client, this._id);
  }

  MemberBoards get boards => _memberBoards;
}
