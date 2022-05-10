import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:trello_sdk/src/sdk/cards/cards.dart';
import 'package:trello_sdk/src/sdk/members/members.dart';

import '../../cli/cli_commons.dart';
import '../sdk_commons.dart';

void main() {
  //get
  group('card get', () {
    var now = DateTime.now();
    var dateLastActive = now.add(Duration(seconds: 1));
    var dateDue = now.add(Duration(minutes: 1));
    var myIdShort = 123;
    var myPos = 234.123;
    apiTest<TrelloCard>(
        apiCall: (client) =>
            client.trelloClient.card(CardId('my-card-id')).get(),
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
            'due': dateDue.toString(),
            'dueComplete': true,
          },
          'name': 'my-card-name',
          'closed': true,
          'dateLastActivity': dateLastActive.toString(),
          'due': dateDue.toString(),
          'dueComplete': true,
          'idAttachmentCover': 'my-id-attachment-cover',
          'idBoard': 'my-id-board',
          'idChecklists': ['my-id-checklist-1', 'my-id-checklist-2'],
          'idLabels': ['my-id-labels-1', 'my-id-labels-2'],
          'idList': 'my-id-list',
          'idMembers': ['my-id-members-1', 'my-id-members-2'],
          'idMembersVoted': ['my-id-members-voted-1', 'my-id-members-voted-2'],
          'idShort': myIdShort,
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
          'pos': myPos,
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
          testValue(
              'dateLastActivity', (r) => r.dateLastActivity, dateLastActive),
          testValue('due', (r) => r.due, dateDue),
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
          testValue('idShort', (r) => r.idShort, myIdShort),
          testValue('labels', (r) => r.labels, [
            CardLabel('my-label-id-1', 'my-label-id-board-1', 'my-label-name-1',
                'my-label-color-1'),
            CardLabel('my-label-id-2', 'my-label-id-board-2', 'my-label-name-2',
                'my-label-color-2'),
          ]),
          testValue(
              'manualCoverAttachment', (r) => r.manualCoverAttachment, isTrue),
          testValue('name', (r) => r.name, 'my-card-name'),
          testValue('pos', (r) => r.pos, myPos),
          testValue('shortLink', (r) => r.shortLink, 'my-short-link'),
          testValue('shortUrl', (r) => r.shortUrl, 'my-short-url'),
          testValue('subscribed', (r) => r.subscribed, isTrue),
          testValue('url', (r) => r.url, 'my-url'),
          testValue('address', (r) => r.address, 'my-address'),
          testValue('locationName', (r) => r.locationName, 'my-location-name'),
          testValue('coordinates', (r) => r.coordinates,
              CardCoordinates(latitude: 12.34, longitude: 45.67)),
          testValue(
              'badges',
              (r) => r.badges,
              CardBadges(345, true, true, 'my-fogbugz', 567, 456, 678, 789,
                  true, dateDue, true)),
        ],
        additionalContext: {});
    apiTest<TrelloCard>(
        apiCall: (client) =>
            client.trelloClient.card(CardId('my-card-id')).get(),
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
        additionalContext: {});
  });
  //put
  group('card put', () {
    var body = {'name': 'my-new-card-name', 'desc': 'my-new-card-desc'};
    apiTest<TrelloCard>(
        apiCall: (client) =>
            client.trelloClient.card(CardId('my-card-id')).put(body),
        expectedMethod: 'PUT',
        expectedPath: '/1/cards/my-card-id',
        expectedHeaders: {
          Headers.contentTypeHeader: Headers.formUrlEncodedContentType,
          Headers.contentLengthHeader: '43',
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
        additionalContext: {});
  });
  //addMember
  group('card addMember', () {
    apiTest(
      apiCall: (client) => client.trelloClient
          .card(CardId('my-card-id'))
          .addMember(MemberId('my-member-id')),
      expectedMethod: 'POST',
      expectedPath: '/1/cards/my-card-id/idMembers',
      expectedHeaders: {Headers.contentTypeHeader: Headers.jsonContentType},
      expectedQueryParameters: {'value': 'my-member-id'},
      existingResourceResponse: createResponse(body: {}),
      responseValues: [],
      additionalContext: {},
    );
  });
  //attachments
  //attachment
}
