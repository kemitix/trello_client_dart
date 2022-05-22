import 'package:test/test.dart';

import '../../../sdk/sdk_commons.dart';
import '../../cli_commons.dart';

void main() {
  group(
      'board list-lists my-board-id',
      () => cliTest(
            arguments: 'board list-lists my-board-id'.split(' '),
            responses: [
              createResponse(body: [
                {
                  'id': 'my-list-id',
                  'name': 'my-list-name',
                  'pos': 1024,
                  'closed': false,
                  'subscribed': true,
                }
              ])
            ],
            expected: CliExpectations(
              requests: [
                ExpectedRequest(
                  expectedMethod: 'GET',
                  expectedPath: '/1/boards/my-board-id/lists',
                  expectedHeaders: {},
                  expectedQueryParameters: {
                    'cards': 'all',
                    'card_fields': 'all',
                    'filter': 'all',
                    'fields': 'id,name,pos,closed,subscribed',
                  },
                )
              ],
              output: [
                'id         | name         |  pos | closed | subscribed',
                '-----------|--------------|------|--------|-----------',
                'my-list-id | my-list-name | 1024 | false  | true      ',
              ],
              help: [
                'Get Lists on a Board',
                '',
                'Usage: trello board list-lists [arguments]',
                '-h, --help      Print this usage information.',
                '    --fields    all or a comma-separated list of fields',
                '                (defaults to "id,name,pos,closed,subscribed")',
                '',
                'Run "trello help" to see global options.'
              ],
              notFoundOutput: [
                'ERROR: board list-lists - Failure: Resource not found: /1/boards/my-board-id/lists - {boardId: my-board-id}'
              ],
              serverErrorOutput: [
                'ERROR: board list-lists - Failure: GET /1/boards/my-board-id/lists - {boardId: my-board-id}'
              ],
            ),
          ));
  group(
      'board list-lists (missing board-id))',
      () => cliTest(
            arguments: 'board list-lists'.split(' '),
            responses: [],
            expected: CliExpectations(
              requests: [],
              output: ['ERROR: board list-lists - Failure: Board Id not given'],
              help: [
                'Get Lists on a Board',
                '',
                'Usage: trello board list-lists [arguments]',
                '-h, --help      Print this usage information.',
                '    --fields    all or a comma-separated list of fields',
                '                (defaults to "id,name,pos,closed,subscribed")',
                '',
                'Run "trello help" to see global options.'
              ],
            ),
          ));
  group(
      'board list-lists --fields',
      () => cliTest(
            arguments:
                'board list-lists --fields id,name my-board-id'.split(' '),
            responses: [
              createResponse(body: [
                {
                  'id': 'my-list-id',
                  'name': 'my-list-name',
                  'pos': 1024,
                  'closed': false,
                  'subscribed': true,
                }
              ])
            ],
            testNotFound: false,
            testServerError: false,
            expected: CliExpectations(
              requests: [
                ExpectedRequest(
                  expectedMethod: 'GET',
                  expectedPath: '/1/boards/my-board-id/lists',
                  expectedHeaders: {},
                  expectedQueryParameters: {
                    'cards': 'all',
                    'card_fields': 'all',
                    'filter': 'all',
                    'fields': 'id,name',
                  },
                )
              ],
              output: [
                'id         | name        ',
                '-----------|-------------',
                'my-list-id | my-list-name',
              ],
              help: [
                'Get Lists on a Board',
                '',
                'Usage: trello board list-lists [arguments]',
                '-h, --help      Print this usage information.',
                '    --fields    all or a comma-separated list of fields',
                '                (defaults to "id,name,pos,closed,subscribed")',
                '',
                'Run "trello help" to see global options.'
              ],
            ),
          ));
}
