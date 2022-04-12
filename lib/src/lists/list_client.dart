import '../http_client.dart';
import 'list_cards.dart';

class Lists {
  final HttpClient _client;
  late final ListCards _listCards;

  Lists(this._client) {
    _listCards = ListCards(_client);
  }

  ListCards get cards => _listCards;
}
