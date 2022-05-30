import 'package:test/test.dart' show group;

import '../../../sdk/sdk_commons.dart' show ExpectedRequest;
import '../../cli_commons.dart' show CliExpectations, cliTest, createResponse;

void main() {
  const helpOutput = [
    'Get Cards in a List',
    '',
    'Usage: trello list list-cards [arguments]',
    '-h, --help      Print this usage information.',
    '    --fields    all or a comma-separated list of fields',
    '                (defaults to "id,name,pos,due")',
    '',
    'Run "trello help" to see global options.'
  ];
  cliTest(
    arguments: 'list list-cards my-list-id'.split(' '),
    responses: [
      createResponse(body: [
        {
          'id': 'my-id',
          'name': 'my-card-name',
          'pos': 1000,
          'due': '2020-04-12',
        }
      ])
    ],
    expectations: CliExpectations(
      requests: [
        ExpectedRequest(
          expectedMethod: 'GET',
          expectedPath: '/1/lists/my-list-id/cards',
          expectedHeaders: {},
          expectedQueryParameters: {},
        )
      ],
      output: [
        'id    | name         |  pos | due       ',
        '------|--------------|------|-----------',
        'my-id | my-card-name | 1000 | 2020-04-12',
      ],
      help: helpOutput,
      notFoundOutput: [
        'ERROR: list list-cards - Failure: Resource not found: /1/lists/my-list-id/cards'
      ],
      serverErrorOutput: [
        'ERROR: list list-cards - Failure: GET /1/lists/my-list-id/cards'
      ],
    ),
  );
  group(
      'no list-id',
      () => cliTest(
          arguments: 'list list-cards'.split(' '),
          responses: [],
          testNotFound: false,
          testServerError: false,
          expectations: CliExpectations(
              requests: [],
              output: ['ERROR: list list-cards - Failure: List Id not given'],
              help: helpOutput)));
}
