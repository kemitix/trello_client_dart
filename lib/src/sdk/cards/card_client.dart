import 'dart:convert';

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
  Future<Either<Failure, TrelloCard>> get({List<CardFields>? fields}) => _client
      .get<dynamic>(
        '/1/cards/$_cardId',
        queryParameters: {
          'fields': asCsv(fields ?? [CardFields.all]),
        },
      )
      .map((response) => response.data)
      .map((data) => TrelloCard(data, fields ?? [CardFields.all]))
      .run();

  /// Get Attachments on a Card
  ///
  /// GET /1/cards/{id}/attachments
  ///
  /// List the attachments on a card
  ///
  /// https://developer.atlassian.com/cloud/trello/rest/api-group-cards/#api-cards-id-attachments-get
  Future<Either<Failure, List<TrelloAttachment>>> attachments({
    AttachmentFilter filter = AttachmentFilter.FALSE,
    List<AttachmentFields>? fields,
  }) =>
      _client
          .get<List<dynamic>>('/1/cards/$_cardId/attachments',
              queryParameters: {
                'filter': filter.toString(),
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
              .toList())
          .run();

  /// Update a Card
  ///
  /// PUT /1/cards/{id}
  ///
  /// Update a card
  ///
  /// https://developer.atlassian.com/cloud/trello/rest/api-group-cards/#api-cards-id-put
  Future<Either<Failure, TrelloCard>> put(Map<String, dynamic> updates) =>
      _client
          .put('/1/cards/$_cardId', data: _formatUpdates(updates), headers: {
            Headers.contentTypeHeader: Headers.jsonContentType,
          })
          .map((response) => response.data)
          .map((data) => TrelloCard(data, [CardFields.all]))
          .run();

  String _formatUpdates(Map<String, dynamic> updates) => json.encode(updates);

  /// Add a Member to a Card
  ///
  /// POST /1/cards/{id}/idMembers
  ///
  /// Add a member to a card
  ///
  /// https://developer.atlassian.com/cloud/trello/rest/api-group-cards/#api-cards-id-idmembers-post
  Future<Either<Failure, HttpResponse<void>>> addMember(MemberId memberId) =>
      _client.post('/1/cards/$_cardId/idMembers', queryParameters: {
        'value': memberId.value,
      }).run();

  /// Remove a Member from a Card
  ///
  /// DELETE /1/cards/{id}/idMembers/{idMember}
  ///
  /// Remove a member from a card
  ///
  /// https://developer.atlassian.com/cloud/trello/rest/api-group-cards/#api-cards-id-idmembers-idmember-delete
  Future<Either<Failure, HttpResponse<void>>> removeMember(MemberId memberId) =>
      _client.delete('/1/cards/$_cardId/idMembers/${memberId.value}').run();
}
