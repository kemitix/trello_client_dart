import 'package:test/test.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../../../mocks/dio_mock.dart';
import '../../cli_commons.dart';

void main() {
  //given
  var memberId = 'my-member-id';
  var client = TestTrelloClient(responses: [
    createResponse(body: {
      'id': 'my-member-id',
      'username': 'my-username',
      'email': 'my-email',
      'fullName': 'my-full-name',
      'initials': 'my-initials',
      'url': 'my-url',
      'status': 'my-status',
      'memberType': 'my-member-type',
      'confirmed': true,
      'bio': 'my-bio',
    })
  ]);
  var printer = FakePrinter();
  var environment = EnvArgsEnvironment(
    platformEnvironment: validEnvironment,
    arguments: 'member get $memberId'.split(' '),
    clientFactory: (_) => client.trelloClient,
    printer: printer.printer,
  );

  //when
  setUpAll(() => app().run(environment));

  //then
  var history = client.fetchHistory;
  test('there was one request', () => expect(history.length, 1));
  test('request was GET', () => expect(history[0].head.method, 'GET'));
  test('request path',
      () => expect(history[0].head.path, '/1/members/$memberId'));
  test(
      'request query parameters',
      () => expect(history[0].head.queryParameters, {
            'boardBackgrounds': 'none',
            'boardStars': 'false',
            'boardsInvited': 'all',
            'boardsInvitedFields': 'all',
            'cars': 'none',
            'customBoardBackground': 'none',
            'customEmoji': 'none',
            'customStickers': 'none',
            'fields': 'all',
            'organizations': 'none',
            'organization_fields': 'all',
            'organization_paid_account': 'false',
            'organizationsInvited': 'none',
            'organizationsInvited_fields': 'all',
            'paid_account': 'false',
            'savedSearches': 'false',
            'tokens': 'none',
          }));
  test(
      'output',
      () => expect(printer.output, [
            'id         | my-member-id  ',
            'username   | my-username   ',
            'email      | my-email      ',
            'fullName   | my-full-name  ',
            'initials   | my-initials   ',
            'url        | my-url        ',
            'status     | my-status     ',
            'memberType | my-member-type',
            'confirmed  | true          ',
            'bio        | my-bio        ',
          ]));
}
