import 'dart:convert' show json;

import 'package:dio/dio.dart' show Headers;

import '../http_client.dart' show HttpClient, HttpResponse;
import '../members/members.dart' show MemberId;
import '../misc.dart' show asCsv;
import '../no_updates_failure.dart';
import '../query_options.dart' show QueryOptions;
import '../trello_authentication.dart' show TrelloAuthentication;
import 'attachment_client.dart' show AttachmentClient;
import 'attachment_fields.dart' show AttachmentFields;
import 'attachment_filter.dart' show AttachmentFilter;
import 'attachment_id.dart' show AttachmentId;
import 'card_fields.dart' show CardFields;
import 'card_id.dart' show CardId;
import 'trello_attachment.dart' show TrelloAttachment;
import 'trello_card.dart' show TrelloCard;

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
  Future<TrelloCard> get({List<CardFields>? fields}) => _client
      .get<dynamic>(QueryOptions(
        path: '/1/cards/$_cardId',
        queryParameters: {
          'fields': asCsv(fields ?? [CardFields.all]),
        },
      ))
      .then((response) => response.data)
      .then((data) => TrelloCard(data, fields ?? [CardFields.all]));

  /// Get Attachments on a Card
  ///
  /// GET /1/cards/{id}/attachments
  ///
  /// List the attachments on a card
  ///
  /// https://developer.atlassian.com/cloud/trello/rest/api-group-cards/#api-cards-id-attachments-get
  Future<List<TrelloAttachment>> attachments({
    AttachmentFilter filter = AttachmentFilter.falsE,
    List<AttachmentFields>? fields,
  }) =>
      _client
          .get<List<dynamic>>(QueryOptions(
            path: '/1/cards/$_cardId/attachments',
            queryParameters: {
              'filter': filter.toString(),
              'fields': asCsv(fields ?? [AttachmentFields.all]),
            },
            headers: {
              'Authorization':
                  'OAuth oauth_consumer_key="${_authentication.key}", '
                      'oauth_token="${_authentication.token}"',
            },
          ))
          .then((response) => response.data ?? [])
          .then((items) => items
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
  Future<TrelloCard> put(Map<String, dynamic> updates) {
    if (updates.isEmpty) return Future.error(NoUpdatesFailure());
    return _client
        .put(
          QueryOptions(
            path: '/1/cards/$_cardId',
            headers: {
              Headers.contentTypeHeader: Headers.jsonContentType,
            },
          ),
          data: _formatUpdates(updates),
        )
        .then((response) => TrelloCard(response.data, [CardFields.all]));
  }

  String _formatUpdates(Map<String, dynamic> updates) => json.encode(updates);

  /// Add a Member to a Card
  ///
  /// POST /1/cards/{id}/idMembers
  ///
  /// Add a member to a card
  ///
  /// https://developer.atlassian.com/cloud/trello/rest/api-group-cards/#api-cards-id-idmembers-post
  Future<HttpResponse<void>> addMember(MemberId memberId) =>
      _client.post(QueryOptions(
        path: '/1/cards/$_cardId/idMembers',
        queryParameters: {
          'value': memberId.value,
        },
      ));

  /// Remove a Member from a Card
  ///
  /// DELETE /1/cards/{id}/idMembers/{idMember}
  ///
  /// Remove a member from a card
  ///
  /// https://developer.atlassian.com/cloud/trello/rest/api-group-cards/#api-cards-id-idmembers-idmember-delete
  Future<HttpResponse<void>> removeMember(MemberId memberId) =>
      _client.delete(QueryOptions(
        path: '/1/cards/$_cardId/idMembers/${memberId.value}',
      ));
}
