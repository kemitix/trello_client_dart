import '../http_client.dart';
import '../misc.dart';
import 'card_models.dart';

class CardClient {
  final HttpClient _client;
  final String _id;

  CardClient(this._client, this._id);

  /// Get a Card
  ///
  /// GET /1/cards/{id}
  ///
  /// Get a card by its ID
  ///
  /// https://developer.atlassian.com/cloud/trello/rest/api-group-cards/#api-cards-id-get
  Future<Card?> get({List<CardFields>? fields}) async => _client
      .get<dynamic>(
        '/1/cards/${_id}',
        queryParameters: {
          'fields': listEnumToCsv(fields ?? [CardFields.all]),
        },
      )
      .then((response) => response.data)
      .then((data) => Card(data, fields ?? [CardFields.all]));
}
