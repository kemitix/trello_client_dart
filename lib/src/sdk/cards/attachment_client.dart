import '../client.dart';
import '../http_client.dart';
import '../query_options.dart';
import 'cards.dart';

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
  Future<TrelloAttachment> get({List<AttachmentFields>? fields}) => _client
      .get<Map<String, dynamic>>(QueryOptions(
        path: '/1/cards/$_cardId/attachments/$_attachmentId',
      ))
      .then((response) => response.data)
      .then((data) => TrelloAttachment(data, fields ?? [AttachmentFields.all]));

  /// Download an Attachment on a Card
  ///
  /// GET (url from 'Get an Attachment on a Card')
  ///
  /// Download an attachment and save it to disk.
  Future<TrelloAttachment> download(FileName fileName) =>
      get(fields: [AttachmentFields.url, AttachmentFields.bytes])
          .then((attachment) => _client
              .download(
                QueryOptions(
                  path: attachment.url,
                  headers: {
                    'Authorization':
                        'OAuth oauth_consumer_key="${_authentication.key}", '
                            'oauth_token="${_authentication.token}"',
                  },
                ),
                fileName,
              )
              .then((_) => attachment));
}
