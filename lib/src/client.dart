import 'package:trello_client/src/http_client.dart';
import 'package:trello_client/src/members.dart';

class TrelloAuthentication {
  final String _key;
  String get key => _key;

  final String _secret;
  String get token => _secret;

  final String _username;
  String get username => _username;

  TrelloAuthentication.of(this._username, this._key, this._secret);
}

class TrelloClient {
  final TrelloAuthentication _keys;
  late final HttpClient _httpClient;
  late final Members _members;

  TrelloClient(this._keys) {
    _httpClient = DioHttpClient(
      baseUrl: 'https://api.trello.com',
      queryParameters: {
        'key': _keys.key,
        'token': _keys.token,
      },
    );
    _members = Members(this);
  }

  String get username => _keys.username;
  Members get members => _members;
  HttpClient get httpClient => _httpClient;

  void close() {
    _httpClient.close();
  }
}
