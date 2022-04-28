import '../../trello_sdk.dart';
import 'boards/boards.dart';
import 'cards/cards.dart';
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
  late final Function1<MemberId, MemberClient> _member;
  late final Function1<BoardId, BoardClient> _board;
  late final Function1<ListId, ListClient> _list;
  late final Function1<CardId, CardClient> _card;

  TrelloClient(this._httpClient, TrelloAuthentication authentication) {
    _memberId = authentication.memberId;
    _member = (id) => MemberClient(_httpClient, id);
    _board = (id) => BoardClient(_httpClient, id);
    _list = (id) => ListClient(_httpClient, id);
    _card = (id) => CardClient(_httpClient, id, authentication);
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

abstract class StringValue {
  final String value;
  StringValue(this.value);

  @override
  String toString() {
    return value;
  }
}
