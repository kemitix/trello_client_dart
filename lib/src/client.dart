import 'package:trello_client/src/boards/boards.dart';
import 'package:trello_client/src/cards/cards.dart';
import 'package:trello_client/src/http_client.dart';
import 'package:trello_client/src/lists/lists.dart';
import 'package:trello_client/src/members/members.dart';

import 'fp/fp.dart';

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
  late final Lists _lists;
  late final Cards _cards;

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
    _lists = Lists(_httpClient);
    _cards = Cards(_httpClient);
  }

  String get username => _username;
  MemberClient member(String id) => _member(id);
  BoardClient board(String id) => _board(id);
  Lists get lists => _lists;
  Cards get cards => _cards;

  void close() {
    _httpClient.close();
  }
}
