import 'package:test/test.dart' show group;

import '../../../sdk/sdk_commons.dart' show ExpectedRequest;
import '../../cli_commons.dart' show CliExpectations, cliTest, createResponse;

void main() {
  const helpOutput = [
    'Get a Member',
    '',
    'Usage: trello member get [arguments]',
    '-h, --help      Print this usage information.',
    '    --fields    all or a comma-separated list of fields',
    '                (defaults to "id,username,email,fullName,initials,url,status,memberType,confirmed,bio")',
    '',
    'Run "trello help" to see global options.'
  ];
  cliTest(
      arguments: 'member get my-member-id'.split(' '),
      responses: [
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
      ],
      expectations: CliExpectations(
        requests: [
          ExpectedRequest(
            expectedMethod: 'GET',
            expectedPath: '/1/members/my-member-id',
            expectedHeaders: {},
            expectedQueryParameters: {
              'boardBackgrounds': 'none',
              'boardStars': 'false',
              'boardsInvited': 'all',
              'boardsInvitedFields': 'all',
              'cars': 'none',
              'customBoardBackground': 'none',
              'customEmoji': 'none',
              'customStickers': 'none',
              'fields':
                  'id,username,email,fullName,initials,url,status,memberType,confirmed,bio',
              'organizations': 'none',
              'organization_fields': 'all',
              'organization_paid_account': 'false',
              'organizationsInvited': 'none',
              'organizationsInvited_fields': 'all',
              'paid_account': 'false',
              'savedSearches': 'false',
              'tokens': 'none',
            },
          )
        ],
        output: [
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
        ],
        help: helpOutput,
        notFoundOutput: [
          'ERROR: member get - Failure: Resource not found: /1/members/my-member-id'
        ],
        serverErrorOutput: [
          'ERROR: member get - Failure: GET /1/members/my-member-id'
        ],
      ));
  group(
      'no member-id',
      () => cliTest(
          arguments: 'member get'.split(' '),
          responses: [],
          expectations: CliExpectations(
              requests: [],
              output: ['ERROR: member get - Failure: Member Id not given'],
              help: helpOutput)));
}
