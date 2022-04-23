import 'package:dartz/dartz.dart';

import '../../../trello_sdk.dart';
import '../http_client.dart';

class CardClient {
  CardClient(this._client, this._cardId, this._authentication) {
    _attachment =
        (id) => AttachmentClient(_client, _cardId, id, _authentication);
  }
  final HttpClient _client;
  final CardId _cardId;
  final TrelloAuthentication _authentication;
  late final Function1<AttachmentId, AttachmentClient> _attachment;

  AttachmentClient attachment(AttachmentId id) => _attachment(id);

  /// Get a Card
  ///
  /// GET /1/cards/{id}
  ///
  /// Get a card by its ID
  ///
  /// https://developer.atlassian.com/cloud/trello/rest/api-group-cards/#api-cards-id-get
  Future<Either<Failure, TrelloCard>> get({List<CardFields>? fields}) async =>
      (await _client.get<dynamic>(
        '/1/cards/$_cardId',
        queryParameters: {
          'fields': asCsv(fields ?? [CardFields.all]),
        },
      ))
          .map((response) => response.data)
          .filter((data) => data != null,
              () => ResourceNotFoundFailure(resource: 'Card ID: $_cardId'))
          .map((data) => TrelloCard(data, fields ?? [CardFields.all]));

  /// Get Attachments on a Card
  ///
  /// GET /1/cards/{id}/attachments
  ///
  /// List the attachments on a card
  ///
  /// https://developer.atlassian.com/cloud/trello/rest/api-group-cards/#api-cards-id-attachments-get
  Future<Either<Failure, List<TrelloAttachment>>> attachments({
    AttachmentFilter filter = AttachmentFilter.falsE,
    List<AttachmentFields>? fields,
  }) async =>
      (await _client.get<List<dynamic>>('/1/cards/$_cardId/attachments',
              queryParameters: {
            'filter': filter.name.toLowerCase(),
            'fields': asCsv(fields ?? [AttachmentFields.all]),
          },
              headers: {
            'Authorization':
                'OAuth oauth_consumer_key="${_authentication.key}", '
                    'oauth_token="${_authentication.token}"',
          }))
          .map((response) => response.data ?? [])
          .map((items) => items
              .map((item) =>
                  TrelloAttachment(item, fields ?? [AttachmentFields.all]))
              .toList());

  Future<Either<Failure, TrelloCard>> put(TrelloCard card) async =>
      (await _client.put('/1/cards/$_cardId', data: card))
          .map((response) => response.data)
          .map((data) => TrelloCard(data, [CardFields.all]));
}
