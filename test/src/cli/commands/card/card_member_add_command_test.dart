import 'package:test/test.dart';

import '../../../sdk/sdk_commons.dart';
import '../../cli_commons.dart';

void main() {
  var helpOutput = [
    'Add a Member to a Card',
    '',
    'Usage: trello card add-member [arguments]',
    '-h, --help    Print this usage information.',
    '',
    'Run "trello help" to see global options.'
  ];
  group('not already a member', () {
    cliTest(
        arguments: 'card add-member my-card-id my-member-id'.split(' '),
        responses: [
          createResponse(body: {
            'id': 'my-card-id',
            'pos': 'my-pos',
            'name': 'my-card-name',
            'due': '2022-05-05T09:45',
            'idMembers': [],
          }),
          createResponse(body: {})
        ],
        expectations: CliExpectations(
          requests: [
            ExpectedRequest(
              expectedMethod: 'GET',
              expectedPath: '/1/cards/my-card-id',
              expectedHeaders: {},
              expectedQueryParameters: {'fields': 'idMembers'},
            ),
            ExpectedRequest(
              expectedMethod: 'POST',
              expectedPath: '/1/cards/my-card-id/idMembers',
              expectedHeaders: {
                'content-type': 'application/json; charset=utf-8'
              },
              expectedQueryParameters: {'value': 'my-member-id'},
            ),
          ],
          output: ['Added member'],
          help: helpOutput,
          notFoundOutput: [
            'ERROR: card add-member - Failure: Resource not found: /1/cards/my-card-id'
          ],
          serverErrorOutput: [
            'ERROR: card add-member - Failure: GET /1/cards/my-card-id'
          ],
        ));
  });
  group('is already a member', () {
    cliTest(
        arguments: 'card add-member my-card-id my-member-id'.split(' '),
        responses: [
          createResponse(body: {
            'id': 'my-card-id',
            'pos': 'my-pos',
            'name': 'my-card-name',
            'due': '2022-05-05T09:45',
            'idMembers': ['my-member-id'],
          }),
        ],
        testNotFound: false,
        testServerError: false,
        expectations: CliExpectations(
          requests: [
            ExpectedRequest(
                expectedMethod: 'GET',
                expectedPath: '/1/cards/my-card-id',
                expectedHeaders: {},
                expectedQueryParameters: {'fields': 'idMembers'})
          ],
          output: [
            'ERROR: card add-member - Failure: Can\'t Add a Member to a Card as it is already applied'
          ],
          help: helpOutput,
        ));
  });
  group(
      'no member-id',
      () => cliTest(
          arguments: 'card add-member my-card-id'.split(' '),
          responses: [],
          expectations: CliExpectations(
              requests: [],
              output: ['ERROR: card add-member - Failure: Member Id not given'],
              help: helpOutput)));
  group(
      'no card-id, member-id',
      () => cliTest(
          arguments: 'card add-member'.split(' '),
          responses: [],
          expectations: CliExpectations(
              requests: [],
              output: ['ERROR: card add-member - Failure: Card Id not given'],
              help: helpOutput)));
}
