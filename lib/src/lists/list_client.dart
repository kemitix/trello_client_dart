import 'package:trello_client/src/http_client.dart';
import 'package:trello_client/src/lists/list_cards.dart';

class Lists {
  final HttpClient _client;
  late final ListCards _listCards;

  Lists(this._client) {
    _listCards = ListCards(_client);
  }

  ListCards get cards => _listCards;
}
