import 'package:trello_client/src/boards/board_lists.dart';
import 'package:trello_client/src/http_client.dart';

class Boards {
  final HttpClient _client;
  late final BoardLists _boardLists;

  Boards(this._client) {
    _boardLists = BoardLists(_client);
  }

  BoardLists get lists => _boardLists;
}
