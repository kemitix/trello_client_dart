import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:trello_sdk/src/sdk/boards/board_models.dart';
import 'package:trello_sdk/src/sdk/errors.dart';
import 'package:trello_sdk/src/sdk/members/members.dart';
import 'package:trello_sdk/src/sdk/trello_models.dart';

import '../../cli/cli_commons.dart';
import '../../mocks/dio_mock.dart';
import '../sdk_commons.dart';

void main() {
  group('get', () {
    //given
    var memberId = 'my-member-id';
    var client = TestTrelloClient(responses: [
      createResponse(body: {
        'id': 'my-member-id',
        'fullName': 'my-full-name',
        'url': 'my-url',
        'username': 'my-username',
        'email': 'my-email',
        'initials': 'my-initials',
        'confirmed': true,
        'memberType': 'my-member-type',
        'status': 'my-status',
        'bio': 'my-bio',
        'activityBlocked': true,
      })
    ]);
    var memberClient = client.trelloClient.member(MemberId(memberId));
    late Either<Failure, TrelloMember> member;

    //when
    setUpAll(() async => member = await memberClient.get(
          boardBackgrounds: MemberBoardBackgrounds.all,
          boardStars: false,
          boardsInvited: [BoardsInvited.pinned],
          boardsInvitedFields: [
            BoardsInvitedFields.closed,
            BoardsInvitedFields.limits
          ],
          cards: MemberCards.open,
          customBoardBackground: MemberCustomBoardBackground.all,
          customEmoji: MemberCustomEmoji.all,
          customStickers: MemberCustomStickers.all,
          fields: [MemberFields.limits, MemberFields.memberType],
          organizations: MemberOrganizations.public,
          organizationFields: [MemberOrganizationFields.name],
          organizationPaidAccount: true,
          organizationsInvited: MemberOrganizationsInvited.public,
          organizationsInvitedFields: [MemberOrganizationsInvitedFields.name],
          paidAccount: true,
          savedSearches: true,
          tokens: MemberTokens.all,
          actions: 'my-actions',
          boards: 'my-boards',
          notifications: 'my-notifications',
        ));

    //then
    group('request', () {
      late RequestOptions request;
      setUpAll(() => request = client.fetchHistory[0].head);
      test('method', () => expect(request.method, 'GET'));
      test('path', () => expect(request.path, '/1/members/my-member-id'));
      test(
          'query parameters',
          () => expect(request.queryParameters, {
                'boardBackgrounds': 'all',
                'boardStars': 'false',
                'boardsInvited': 'pinned',
                'boardsInvitedFields': 'closed,limits',
                'cars': 'open',
                'customBoardBackground': 'all',
                'customEmoji': 'all',
                'customStickers': 'all',
                'fields': 'limits,memberType',
                'organizations': 'public',
                'organization_fields': 'name',
                'organization_paid_account': 'true',
                'organizationsInvited': 'public',
                'organizationsInvited_fields': 'name',
                'paid_account': 'true',
                'savedSearches': 'true',
                'tokens': 'all',
                'actions': 'my-actions',
                'boards': 'my-boards',
                'notifications': 'my-notifications'
              }));
    });
    group('response', () {
      test(
          'member id',
          () async => verify<TrelloMember>(
              member, (r) => expect(r.id, MemberId(memberId))));
      test(
          'member full name',
          () async => verify<TrelloMember>(
              member, (r) => expect(r.fullName, 'my-full-name')));
      test(
          'member url',
          () async =>
              verify<TrelloMember>(member, (r) => expect(r.url, 'my-url')));
      test(
          'member username',
          () async => verify<TrelloMember>(
              member, (r) => expect(r.username, 'my-username')));
      test(
          'member email',
          () async =>
              verify<TrelloMember>(member, (r) => expect(r.email, 'my-email')));
      test(
          'member initials',
          () async => verify<TrelloMember>(
              member, (r) => expect(r.initials, 'my-initials')));
      test(
          'member confirmed',
          () async =>
              verify<TrelloMember>(member, (r) => expect(r.confirmed, isTrue)));
      test(
          'member member type',
          () async => verify<TrelloMember>(
              member, (r) => expect(r.memberType, 'my-member-type')));
      test(
          'member status',
          () async => verify<TrelloMember>(
              member, (r) => expect(r.status, 'my-status')));
      test(
          'member bio',
          () async =>
              verify<TrelloMember>(member, (r) => expect(r.bio, 'my-bio')));
      test(
          'member activity blocked',
          () async => verify<TrelloMember>(
              member, (r) => expect(r.raw['activityBlocked'], isTrue)));
    });
  });
  group('getBoards', () {
    //given
    var memberId = 'my-member-id';
    var client = TestTrelloClient(responses: [
      createResponse(body: [
        {
          'id': 'my-board-id',
          'name': 'my-board-name',
          'desc': 'my-board-desc',
          'descData': 'my-desc-data',
          'closed': true,
          'idMemberCreator': 'my-creator-member-id',
          'idOrganization': 'my-org-id',
          'pinned': true,
          'url': 'my-board-url',
          'shortUrl': 'my-short-url',
          'starred': true,
          'memberships': 'my-board-memberships',
          'enterpriseOwned': 'my-enterprise-owned',
        }
      ])
    ]);
    var memberClient = client.trelloClient.member(MemberId(memberId));
    late Either<Failure, List<TrelloBoard>> boards;

    //when
    setUpAll(() async => boards = await memberClient.getBoards(
        filter: MemberBoardFilter.closed, fields: [BoardFields.all]));

    //then
    group('request', () {
      late RequestOptions request;
      setUpAll(() => request = client.fetchHistory[0].head);
      test('request method', () => expect(request.method, 'GET'));
      test('request url',
          () => expect(request.path, '/1/members/my-member-id/boards'));
      test(
          'request query parameters',
          () => expect(request.queryParameters, {
                'filter': 'closed',
                'fields': 'all',
              }));
    });
    group('response', () {
      late Either<Failure, TrelloBoard> board;
      setUpAll(() => board = boards.map((list) => list[0]));
      test('one item in list',
          () => boards.map((list) => expect(list.length, 1)));
      test(
          'board id',
          () async => verify<TrelloBoard>(
              board, (r) => expect(r.id, BoardId('my-board-id'))));
      test(
          'board name',
          () async => verify<TrelloBoard>(
              board, (r) => expect(r.name, 'my-board-name')));
      test(
          'board desc',
          () async => verify<TrelloBoard>(
              board, (r) => expect(r.desc, 'my-board-desc')));
      test(
          'board descData',
          () async => verify<TrelloBoard>(
              board, (r) => expect(r.descData, 'my-desc-data')));
      test(
          'board closed',
          () async =>
              verify<TrelloBoard>(board, (r) => expect(r.closed, isTrue)));
      test(
          'board idMemberCreator',
          () async => verify<TrelloBoard>(
              board,
              (r) =>
                  expect(r.idMemberCreator, MemberId('my-creator-member-id'))));
      test(
          'board idOrganization',
          () async => verify<TrelloBoard>(
              board, (r) => expect(r.idOrganization, 'my-org-id')));
      test(
          'board pinned',
          () async =>
              verify<TrelloBoard>(board, (r) => expect(r.pinned, isTrue)));
      test(
          'board url',
          () async =>
              verify<TrelloBoard>(board, (r) => expect(r.url, 'my-board-url')));
      test(
          'board shortUrl',
          () async => verify<TrelloBoard>(
              board, (r) => expect(r.shortUrl, 'my-short-url')));
      test(
          'board starred',
          () async =>
              verify<TrelloBoard>(board, (r) => expect(r.starred, isTrue)));
      test(
          'board memberships',
          () async => verify<TrelloBoard>(
              board, (r) => expect(r.memberships, 'my-board-memberships')));
      test(
          'board enterprise owned',
          () async => verify<TrelloBoard>(
              board, (r) => expect(r.enterpriseOwned, 'my-enterprise-owned')));
    });
  });
}
