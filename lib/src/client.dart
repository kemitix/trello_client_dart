import 'boards/boards.dart';
import 'cards/cards.dart';
import 'fp/fp.dart';
import 'http_client.dart';
import 'lists/lists.dart';
import 'members/members.dart';

class TrelloAuthentication {
  final String _key;
  String get key => _key;

  final String _token;
  String get token => _token;

  final MemberId _memberId;
  MemberId get memberId => _memberId;

  TrelloAuthentication.of(this._memberId, this._key, this._token);
}

class TrelloClient {
  late final MemberId _memberId;
  late final HttpClient _httpClient;
  late final Fn<MemberId, MemberClient> _member;
  late final Fn<BoardId, BoardClient> _board;
  late final Fn<ListId, ListClient> _list;
  late final Fn<CardId, CardClient> _card;

  TrelloClient(TrelloAuthentication authentication) {
    _httpClient = DioHttpClient(
      baseUrl: 'https://api.trello.com',
      queryParameters: {
        'key': authentication.key,
        'token': authentication.token,
      },
    );
    _memberId = authentication.memberId;
    _member = (id) => MemberClient(_httpClient, id);
    _board = (id) => BoardClient(_httpClient, id);
    _list = (id) => ListClient(_httpClient, id);
    _card = (id) => CardClient(_httpClient, id);
  }

  MemberId get memberId => _memberId;

  MemberClient member(MemberId id) => _member(id);
  BoardClient board(BoardId id) => _board(id);
  ListClient list(ListId id) => _list(id);
  CardClient card(CardId id) => _card(id);

  void close() {
    _httpClient.close();
  }
}

abstract class StringId {
  final String id;
  StringId(this.id);

  @override
  String toString() {
    return id;
  }
}
