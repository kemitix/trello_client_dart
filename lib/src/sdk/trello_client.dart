import 'boards/boards.dart' show BoardClient, BoardId;
import 'cards/cards.dart' show CardClient, CardId;
import 'http_client.dart' show HttpClient;
import 'lists/lists.dart' show ListClient, ListId;
import 'members/members.dart' show MemberClient, MemberId;
import 'trello_authentication.dart' show TrelloAuthentication;

class TrelloClient {
  late final HttpClient _httpClient;
  late final MemberClient Function(MemberId) _member;
  late final BoardClient Function(BoardId) _board;
  late final ListClient Function(ListId) _list;
  late final CardClient Function(CardId) _card;

  TrelloClient(this._httpClient, TrelloAuthentication authentication) {
    _member = (id) => MemberClient(_httpClient, id);
    _board = (id) => BoardClient(_httpClient, id);
    _list = (id) => ListClient(_httpClient, id);
    _card = (id) => CardClient(_httpClient, id, authentication);
  }

  MemberClient member(MemberId id) => _member(id);

  BoardClient board(BoardId id) => _board(id);

  ListClient list(ListId id) => _list(id);

  CardClient card(CardId id) => _card(id);

  void close() {
    _httpClient.close();
  }
}
