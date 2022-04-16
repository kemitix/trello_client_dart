import '../http_client.dart';
import '../misc.dart';
import 'cards.dart';

class CardClient {
  final HttpClient _client;
  final CardId _id;

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
        '/1/cards/$_id',
        queryParameters: {
          'fields': asCsv(fields ?? [CardFields.all]),
        },
      )
      .then((response) => response.data)
      .then((data) => Card(data, fields ?? [CardFields.all]));

  /// Get Attachments on a Card
  ///
  /// GET /1/cards/{id}/attachments
  ///
  /// List the attachments on a card
  Future<List<Attachment>> getAttachments({
    AttachmentFilter filter = AttachmentFilter.FALSE,
    List<AttachmentFields>? fields,
  }) async =>
      ((await _client.get<dynamic>('/1/cards/$_id/attachments',
                      queryParameters: {
                    'filter': filter.name,
                    'fields': asCsv(fields ?? [AttachmentFields.all]),
                  }))
                  .data ??
              [])
          .map((data) => Attachment(data, fields ?? [AttachmentFields.all]))
          .toList();
}
