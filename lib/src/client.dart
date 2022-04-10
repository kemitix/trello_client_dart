import 'package:trello_client/src/boards/boards.dart';
import 'package:trello_client/src/http_client.dart';
import 'package:trello_client/src/lists/lists.dart';
import 'package:trello_client/src/members.dart';

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
  late final Members _members;
  late final Boards _boards;
  late final Lists _lists;

  TrelloClient(TrelloAuthentication authentication) {
    _httpClient = DioHttpClient(
      baseUrl: 'https://api.trello.com',
      queryParameters: {
        'key': authentication.key,
        'token': authentication.token,
      },
    );
    _username = authentication.username;
    _members = Members(_httpClient);
    _boards = Boards(_httpClient);
    _lists = Lists(_httpClient);
  }

  String get username => _username;
  Members get members => _members;
  Boards get boards => _boards;
  Lists get lists => _lists;

  void close() {
    _httpClient.close();
  }
}
