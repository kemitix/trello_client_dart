import 'package:test/test.dart' show group;

import '../../../sdk/sdk_commons.dart' show ExpectedRequest;
import '../../cli_commons.dart' show CliExpectations, cliTest, createResponse;

void main() {
  const helpOutput = [
    'Get Boards that Member belongs to',
    '',
    'Usage: trello member list-boards [arguments]',
    '-h, --help      Print this usage information.',
    '    --fields    all or a comma-separated list of fields',
    '                (defaults to "id,name,pinned,closed,starred,shortUrl")',
    '',
    'Run "trello help" to see global options.'
  ];
  cliTest(
    arguments: 'member list-boards my-member-id'.split(' '),
    responses: [
      createResponse(body: [
        // get boards
        {
          'id': 'my-id',
          'name': 'my-board-name',
          'pinned': false,
          'closed': true,
          'starred': false,
          'shortUrl': 'my-short-url',
        },
      ]),
    ],
    expectations: CliExpectations(
      requests: [
        ExpectedRequest(
          expectedMethod: 'GET',
          expectedPath: '/1/members/my-member-id/boards',
          expectedHeaders: {},
          expectedQueryParameters: {
            'filter': 'all',
            'fields': 'id,name,pinned,closed,starred,shortUrl'
          },
        ),
      ],
      output: [
        'id    | name          | pinned | closed | starred | shortUrl    ',
        '------|---------------|--------|--------|---------|-------------',
        'my-id | my-board-name | false  | true   | false   | my-short-url',
      ],
      help: helpOutput,
      notFoundOutput: [
        'ERROR: member list-boards - Failure: Resource not found: /1/members/my-member-id/boards'
      ],
      serverErrorOutput: [
        'ERROR: member list-boards - Failure: GET /1/members/my-member-id/boards'
      ],
    ),
  );
  group(
      'no member-id',
      () => cliTest(
            arguments: 'member list-boards'.split(' '),
            responses: [],
            testNotFound: false,
            testServerError: false,
            expectations: CliExpectations(
              requests: [],
              output: [
                'ERROR: member list-boards - Failure: Member Id not given'
              ],
              help: helpOutput,
            ),
          ));
}
