import 'package:dio/dio.dart' show Headers;
import 'package:test/test.dart' show group, isTrue;
import 'package:trello_sdk/trello_sdk.dart'
    show
        AttachmentId,
        CardBadges,
        CardCoordinates,
        CardId,
        CardLabel,
        FileName,
        MemberId,
        TrelloAttachment,
        TrelloCard;

import '../../cli/cli_commons.dart' show createResponse;
import '../sdk_commons.dart'
    show ExpectedRequestWithResponseTests, apiTest, testValue;

void main() {
  //get
  group(
      'card get 1 of 2',
      () => apiTest<TrelloCard>(
              apiCall: (client) =>
                  client.trelloClient.card(CardId('my-card-id')).get(),
              expectedRequests: [
                ExpectedRequestWithResponseTests<TrelloCard>(
                    expectedMethod: 'GET',
                    expectedPath: '/1/cards/my-card-id',
                    expectedQueryParameters: {'fields': 'all'},
                    existingResourceResponse: createResponse(body: {
                      'id': 'my-card-id',
                      'badges': {
                        // 'attachmentsByType': {
                        //   'trello': {
                        //     'board': 123,
                        //     'card': 234,
                        //   }
                        // },
                        'location': true,
                        'votes': 345,
                        'viewingMemberVoted': true,
                        'subscribed': true,
                        'fogbugz': 'my-fogbugz',
                        'checkItems': 567,
                        'checkItemsChecked': 456,
                        'comments': 678,
                        'attachments': 789,
                        'description': true,
                        'due': DateTime(2022, 04, 05).toString(),
                        'dueComplete': true,
                      },
                      'name': 'my-card-name',
                      'closed': true,
                      'dateLastActivity': DateTime(2022, 04, 07).toString(),
                      'due': DateTime(2022, 04, 06).toString(),
                      'dueComplete': true,
                      'idAttachmentCover': 'my-id-attachment-cover',
                      'idBoard': 'my-id-board',
                      'idChecklists': [
                        'my-id-checklist-1',
                        'my-id-checklist-2'
                      ],
                      'idLabels': ['my-id-labels-1', 'my-id-labels-2'],
                      'idList': 'my-id-list',
                      'idMembers': ['my-id-members-1', 'my-id-members-2'],
                      'idMembersVoted': [
                        'my-id-members-voted-1',
                        'my-id-members-voted-2'
                      ],
                      'idShort': 123,
                      'labels': [
                        {
                          'id': 'my-label-id-1',
                          'idBoard': 'my-label-id-board-1',
                          'name': 'my-label-name-1',
                          'color': 'my-label-color-1'
                        },
                        {
                          'id': 'my-label-id-2',
                          'idBoard': 'my-label-id-board-2',
                          'name': 'my-label-name-2',
                          'color': 'my-label-color-2'
                        },
                      ],
                      'manualCoverAttachment': true,
                      'pos': 234.123,
                      'shortLink': 'my-short-link',
                      'shortUrl': 'my-short-url',
                      'subscribed': true,
                      'url': 'my-url',
                      'address': 'my-address',
                      'locationName': 'my-location-name',
                      'coordinates': '12.34,45.67',
                    }),
                    expectedHeaders: {},
                    responseValues: [
                      testValue('id', (r) => r.id, CardId('my-card-id')),
                      testValue('closed', (r) => r.closed, isTrue),
                      testValue('dateLastActivity', (r) => r.dateLastActivity,
                          DateTime(2022, 04, 07)),
                      testValue('due', (r) => r.due, DateTime(2022, 04, 06)),
                      testValue('dueComplete', (r) => r.dueComplete, isTrue),
                      testValue('idAttachmentCover', (r) => r.idAttachmentCover,
                          'my-id-attachment-cover'),
                      testValue('idBoard', (r) => r.idBoard, 'my-id-board'),
                      testValue('idChecklists', (r) => r.idChecklists,
                          ['my-id-checklist-1', 'my-id-checklist-2']),
                      testValue('idLabels', (r) => r.idLabels,
                          ['my-id-labels-1', 'my-id-labels-2']),
                      testValue('idList', (r) => r.idList, 'my-id-list'),
                      testValue('idMembers', (r) => r.idMembers,
                          ['my-id-members-1', 'my-id-members-2']),
                      testValue('idMembersVoted', (r) => r.idMembersVoted,
                          ['my-id-members-voted-1', 'my-id-members-voted-2']),
                      testValue('idShort', (r) => r.idShort, 123),
                      testValue('labels', (r) => r.labels, [
                        CardLabel('my-label-id-1', 'my-label-id-board-1',
                            'my-label-name-1', 'my-label-color-1'),
                        CardLabel('my-label-id-2', 'my-label-id-board-2',
                            'my-label-name-2', 'my-label-color-2'),
                      ]),
                      testValue('manualCoverAttachment',
                          (r) => r.manualCoverAttachment, isTrue),
                      testValue('name', (r) => r.name, 'my-card-name'),
                      testValue('pos', (r) => r.pos, 234.123),
                      testValue(
                          'shortLink', (r) => r.shortLink, 'my-short-link'),
                      testValue('shortUrl', (r) => r.shortUrl, 'my-short-url'),
                      testValue('subscribed', (r) => r.subscribed, isTrue),
                      testValue('url', (r) => r.url, 'my-url'),
                      testValue('address', (r) => r.address, 'my-address'),
                      testValue('locationName', (r) => r.locationName,
                          'my-location-name'),
                      testValue('coordinates', (r) => r.coordinates,
                          CardCoordinates(latitude: 12.34, longitude: 45.67)),
                      testValue(
                          'badges',
                          (r) => r.badges,
                          CardBadges(345, true, true, 'my-fogbugz', 567, 456,
                              678, 789, true, DateTime(2022, 04, 05), true)),
                    ],
                    additionalContext: {})
              ]));
  group(
      'card get 2 of 2',
      () => apiTest<TrelloCard>(
            apiCall: (client) =>
                client.trelloClient.card(CardId('my-card-id')).get(),
            expectedRequests: [
              ExpectedRequestWithResponseTests<TrelloCard>(
                  expectedMethod: 'GET',
                  expectedPath: '/1/cards/my-card-id',
                  expectedQueryParameters: {'fields': 'all'},
                  existingResourceResponse: createResponse(body: {
                    'coordinates': {'latitude': 12.34, 'longitude': 45.67},
                  }),
                  expectedHeaders: {},
                  responseValues: [
                    testValue('coordinates', (r) => r.coordinates,
                        CardCoordinates(latitude: 12.34, longitude: 45.67)),
                  ],
                  additionalContext: {})
            ],
          ));
  //put
  group(
      'card put',
      () => apiTest<TrelloCard>(
            apiCall: (client) => client.trelloClient
                .card(CardId('my-card-id'))
                .put({'name': 'my-new-card-name', 'desc': 'my-new-card-desc'}),
            expectedRequests: [
              ExpectedRequestWithResponseTests<TrelloCard>(
                  expectedMethod: 'PUT',
                  expectedPath: '/1/cards/my-card-id',
                  expectedHeaders: {
                    Headers.contentTypeHeader: Headers.jsonContentType,
                    Headers.contentLengthHeader: '53',
                  },
                  expectedQueryParameters: {},
                  existingResourceResponse: createResponse(body: {
                    'id': 'my-card-id',
                    'name': 'my-new-card-name',
                    'desc': 'my-new-card-desc',
                  }),
                  responseValues: [
                    testValue('id', (r) => r.id, CardId('my-card-id')),
                    testValue('name', (r) => r.name, 'my-new-card-name'),
                    testValue('desc', (r) => r.desc, 'my-new-card-desc'),
                  ],
                  additionalContext: {})
            ],
          ));
  //addMember
  group(
      'card addMember',
      () => apiTest(
              apiCall: (client) => client.trelloClient
                  .card(CardId('my-card-id'))
                  .addMember(MemberId('my-member-id')),
              expectedRequests: [
                ExpectedRequestWithResponseTests(
                    expectedMethod: 'POST',
                    expectedPath: '/1/cards/my-card-id/idMembers',
                    expectedHeaders: {
                      Headers.contentTypeHeader: Headers.jsonContentType
                    },
                    expectedQueryParameters: {'value': 'my-member-id'},
                    existingResourceResponse: createResponse(body: {}),
                    responseValues: [],
                    additionalContext: {})
              ]));
  //removeMember
  group(
      'card removeMember',
      () => apiTest(
              apiCall: (client) => client.trelloClient
                  .card(CardId('my-card-id'))
                  .removeMember(MemberId('my-member-id')),
              expectedRequests: [
                ExpectedRequestWithResponseTests(
                    expectedMethod: 'DELETE',
                    expectedPath: '/1/cards/my-card-id/idMembers/my-member-id',
                    expectedHeaders: {
                      Headers.contentTypeHeader: Headers.jsonContentType
                    },
                    expectedQueryParameters: {},
                    existingResourceResponse: createResponse(body: {}),
                    responseValues: [],
                    additionalContext: {})
              ]));
  //attachments
  group(
      'attachments',
      () => apiTest<List<TrelloAttachment>>(
            apiCall: (client) =>
                client.trelloClient.card(CardId('my-card-id')).attachments(),
            expectedRequests: [
              ExpectedRequestWithResponseTests<List<TrelloAttachment>>(
                  expectedMethod: 'GET',
                  expectedPath: '/1/cards/my-card-id/attachments',
                  expectedHeaders: {
                    'Authorization':
                        'OAuth oauth_consumer_key="_key", oauth_token="_token"'
                  },
                  expectedQueryParameters: {'filter': 'false', 'fields': 'all'},
                  existingResourceResponse: createResponse(body: [
                    {
                      'id': 'my-id',
                      'bytes': 'my-bytes',
                      'date': DateTime(2022, 04, 03).toString(),
                      'edgeColor': 'my-edge-color',
                      'idMember': 'my-member-id',
                      'isUpload': true,
                      'mimeType': 'my-mime-type',
                      'name': 'my-name',
                      'previews': ['my-preview-1', 'my-preview-2'],
                      'url': 'my-url',
                      'pos': 123.456,
                    },
                  ]),
                  responseValues: [
                    testValue('id', (r) => r[0].id, 'my-id'),
                    testValue('bytes', (r) => r[0].bytes, 'my-bytes'),
                    testValue('date', (r) => r[0].date, DateTime(2022, 04, 03)),
                    testValue(
                        'edgeColor', (r) => r[0].edgeColor, 'my-edge-color'),
                    testValue('idMember', (r) => r[0].idMember, 'my-member-id'),
                    testValue('isUpload', (r) => r[0].isUpload, isTrue),
                    testValue('mimeType', (r) => r[0].mimeType, 'my-mime-type'),
                    testValue('previews', (r) => r[0].previews,
                        ['my-preview-1', 'my-preview-2']),
                    testValue('url', (r) => r[0].url, 'my-url'),
                    testValue('pos', (r) => r[0].pos, 123.456),
                  ],
                  additionalContext: {})
            ],
          ));
  //attachment
  group(
      'attachment',
      () => apiTest<TrelloAttachment>(
            apiCall: (client) => client.trelloClient
                .card(CardId('my-card-id'))
                .attachment(AttachmentId('my-attachment-id'))
                .get(),
            expectedRequests: [
              ExpectedRequestWithResponseTests<TrelloAttachment>(
                  expectedMethod: 'GET',
                  expectedPath:
                      '/1/cards/my-card-id/attachments/my-attachment-id',
                  expectedHeaders: {},
                  expectedQueryParameters: {},
                  existingResourceResponse: createResponse(
                    body: {
                      'id': 'my-id',
                      'bytes': 'my-bytes',
                      'date': DateTime(2022, 04, 03).toString(),
                      'edgeColor': 'my-edge-color',
                      'idMember': 'my-member-id',
                      'isUpload': true,
                      'mimeType': 'my-mime-type',
                      'name': 'my-name',
                      'previews': ['my-preview-1', 'my-preview-2'],
                      'url': 'my-url',
                      'pos': 123.456,
                    },
                  ),
                  responseValues: [
                    testValue('id', (r) => r.id, 'my-id'),
                    testValue('bytes', (r) => r.bytes, 'my-bytes'),
                    testValue('date', (r) => r.date, DateTime(2022, 04, 03)),
                    testValue('edgeColor', (r) => r.edgeColor, 'my-edge-color'),
                    testValue('idMember', (r) => r.idMember, 'my-member-id'),
                    testValue('isUpload', (r) => r.isUpload, isTrue),
                    testValue('mimeType', (r) => r.mimeType, 'my-mime-type'),
                    testValue('previews', (r) => r.previews,
                        ['my-preview-1', 'my-preview-2']),
                    testValue('url', (r) => r.url, 'my-url'),
                    testValue('pos', (r) => r.pos, 123.456),
                  ],
                  additionalContext: {})
            ],
          ));
  //download
  group(
      'download attachment',
      () => apiTest<TrelloAttachment>(
            apiCall: (client) => client.trelloClient
                .card(CardId('my-card-id'))
                .attachment(AttachmentId('my-attachment-id'))
                .download(FileName('my-file-name')),
            testNotFound: false,
            testServerError: false,
            expectedRequests: [
              ExpectedRequestWithResponseTests<TrelloAttachment>(
                  // get info about attachment, including the download url
                  expectedMethod: 'GET',
                  expectedPath:
                      '/1/cards/my-card-id/attachments/my-attachment-id',
                  expectedHeaders: {},
                  expectedQueryParameters: {},
                  existingResourceResponse: createResponse(
                    body: {
                      'id': 'my-id',
                      'name': 'my-name',
                      'bytes': 'my-bytes',
                      'url': 'my-url',
                    },
                  ),
                  responseValues: [
                    testValue('id', (r) => r.id, 'my-id'),
                    testValue('name', (r) => r.name, 'my-name'),
                    testValue('bytes', (r) => r.bytes, 'my-bytes'),
                    testValue('url', (r) => r.url, 'my-url'),
                  ],
                  additionalContext: {}),
              ExpectedRequestWithResponseTests(
                // download the attachment
                expectedMethod: 'GET',
                expectedPath: 'my-url',
                expectedHeaders: {
                  'Authorization':
                      'OAuth oauth_consumer_key="_key", oauth_token="_token"'
                },
                expectedQueryParameters: {},
                existingResourceResponse: createResponse(body: 'foo'),
                responseValues: [],
                additionalContext: {},
              )
            ],
          ));
}
