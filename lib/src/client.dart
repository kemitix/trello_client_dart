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

  final String _username;
  String get username => _username;

  TrelloAuthentication.of(this._username, this._key, this._token);
}

class TrelloClient {
  late final String _username;
  late final HttpClient _httpClient;
  late final Fn<String, MemberClient> _member;
  late final Fn<String, BoardClient> _board;
  late final Fn<String, ListClient> _list;
  late final Fn<String, CardClient> _card;

  TrelloClient(TrelloAuthentication authentication) {
    _httpClient = DioHttpClient(
      baseUrl: 'https://api.trello.com',
      queryParameters: {
        'key': authentication.key,
        'token': authentication.token,
      },
    );
    _username = authentication.username;
    _member = (id) => MemberClient(_httpClient, id);
    _board = (id) => BoardClient(_httpClient, id);
    _list = (id) => ListClient(_httpClient, id);
    _card = (id) => CardClient(_httpClient, id);
  }

  String get username => _username;
  MemberClient member(String id) => _member(id);
  BoardClient board(String id) => _board(id);
  ListClient list(String id) => _list(id);
  CardClient card(String id) => _card(id);

  void close() {
    _httpClient.close();
  }
}
