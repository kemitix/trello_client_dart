import 'package:dartx/dartx.dart';
import 'package:dio/dio.dart';

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
  late final AttachmentClient Function(AttachmentId) _attachment;

  AttachmentClient attachment(AttachmentId id) => _attachment(id);

  /// Get a Card
  ///
  /// GET /1/cards/{id}
  ///
  /// Get a card by its ID
  ///
  /// https://developer.atlassian.com/cloud/trello/rest/api-group-cards/#api-cards-id-get
  TaskEither<Failure, TrelloCard> get({List<CardFields>? fields}) => _client
      .get<dynamic>(
        '/1/cards/$_cardId',
        queryParameters: {
          'fields': asCsv(fields ?? [CardFields.all]),
        },
      )
      .map((response) => response.data)
      .map((data) => TrelloCard(data, fields ?? [CardFields.all]));

  /// Get Attachments on a Card
  ///
  /// GET /1/cards/{id}/attachments
  ///
  /// List the attachments on a card
  ///
  /// https://developer.atlassian.com/cloud/trello/rest/api-group-cards/#api-cards-id-attachments-get
  TaskEither<Failure, List<TrelloAttachment>> attachments({
    AttachmentFilter filter = AttachmentFilter.falsE,
    List<AttachmentFields>? fields,
  }) =>
      _client
          .get<List<dynamic>>('/1/cards/$_cardId/attachments',
              queryParameters: {
                'filter': filter.name.toLowerCase(),
                'fields': asCsv(fields ?? [AttachmentFields.all]),
              },
              headers: {
                'Authorization':
                    'OAuth oauth_consumer_key="${_authentication.key}", '
                        'oauth_token="${_authentication.token}"',
              })
          .map((response) => response.data ?? [])
          .map((items) => items
              .map((item) =>
                  TrelloAttachment(item, fields ?? [AttachmentFields.all]))
              .toList());

  /// Update a Card
  ///
  /// PUT /1/cards/{id}
  ///
  /// Update a card
  ///
  /// https://developer.atlassian.com/cloud/trello/rest/api-group-cards/#api-cards-id-put
  TaskEither<Failure, TrelloCard> put(Map<String, String> updates) => _client
      .put('/1/cards/$_cardId', data: _formatUpdates(updates), headers: {
        Headers.contentTypeHeader: Headers.formUrlEncodedContentType,
      })
      .map((response) => response.data)
      .map((data) => TrelloCard(data, [CardFields.all]));

  //returns 'name=2022-05-04T20%3A49%3A18%2B01%3A01';
  String _formatUpdates(Map<String, String> updates) => updates.entries
      .map((e) => '${e.key.urlEncode}=${e.value.urlEncode}')
      .join('&');

  /// Add a Member to a Card
  ///
  /// POST /1/cards/{id}/idMembers
  ///
  /// Add a member to a card
  ///
  /// https://developer.atlassian.com/cloud/trello/rest/api-group-cards/#api-cards-id-idmembers-post
  TaskEither<Failure, void> addMember(MemberId memberId) =>
      _client.post('/1/cards/$_cardId/idMembers', queryParameters: {
        'value': memberId.value,
      });
}
