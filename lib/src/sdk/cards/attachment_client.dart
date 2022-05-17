import '../../../trello_sdk.dart';
import '../http_client.dart';

class AttachmentClient {
  AttachmentClient(
      this._client, this._cardId, this._attachmentId, this._authentication);

  final HttpClient _client;
  final CardId _cardId;
  final AttachmentId _attachmentId;
  final TrelloAuthentication _authentication;

  /// Get an Attachment on a Card
  ///
  /// GET /1/cards/{id}/attachments/{idAttachment}
  ///
  /// Get a specific Attachment on a Card.
  ///
  /// https://developer.atlassian.com/cloud/trello/rest/api-group-cards/#api-cards-id-attachments-idattachment-get
  Future<Either<Failure, TrelloAttachment>> get(
          {List<AttachmentFields>? fields}) =>
      _client
          .get<Map<String, dynamic>>(
              '/1/cards/$_cardId/attachments/$_attachmentId')
          .map((response) => response.data)
          .map((data) =>
              TrelloAttachment(data, fields ?? [AttachmentFields.all]))
          .run();

  /// Download an Attachment on a Card
  ///
  /// GET (url from 'Get an Attachment on a Card')
  ///
  /// Download an attachment and save it to disk.
  Future<Either<Failure, TrelloAttachment>> download(FileName fileName) =>
      get(fields: [AttachmentFields.url, AttachmentFields.bytes])
          .then((r) => Either.sequenceFuture(r.map((attachment) => _client
              .download(
                attachment.url,
                fileName,
                headers: {
                  'Authorization':
                      'OAuth oauth_consumer_key="${_authentication.key}", '
                          'oauth_token="${_authentication.token}"',
                },
              )
              .run()
              .then((_) => attachment))));
}
