import 'package:test/test.dart';

import '../../../sdk/sdk_commons.dart';
import '../../cli_commons.dart';

void main() {
  var helpOutput = [
    'Remove a Member from a Card',
    '',
    'Usage: trello card remove-member [arguments]',
    '-h, --help    Print this usage information.',
    '',
    'Run "trello help" to see global options.'
  ];
  group('is a member', () {
    cliTest(
        arguments: 'card remove-member my-card-id my-member-id'.split(' '),
        responses: [
          createResponse(body: {
            'id': 'my-card-id',
            'pos': 'my-pos',
            'name': 'my-card-name',
            'due': '2022-05-05T09:45',
            'idMembers': ['my-member-id'],
          }),
          createResponse(body: {})
        ],
        expected: CliExpectations(
          requests: [
            ExpectedRequest(
              expectedMethod: 'GET',
              expectedPath: '/1/cards/my-card-id',
              expectedHeaders: {},
              expectedQueryParameters: {'fields': 'idMembers'},
            ),
            ExpectedRequest(
              expectedMethod: 'DELETE',
              expectedPath: '/1/cards/my-card-id/idMembers/my-member-id',
              expectedHeaders: {
                'content-type': 'application/json; charset=utf-8'
              },
              expectedQueryParameters: {},
            ),
          ],
          output: ['Removed member'],
          help: helpOutput,
          notFoundOutput: [
            'ERROR: card remove-member - Failure: Resource not found: /1/cards/my-card-id'
          ],
          serverErrorOutput: [
            'ERROR: card remove-member - Failure: GET /1/cards/my-card-id'
          ],
        ));
  });
  group('is not a member', () {
    cliTest(
        arguments: 'card remove-member my-card-id my-member-id'.split(' '),
        responses: [
          createResponse(body: {
            'id': 'my-card-id',
            'pos': 'my-pos',
            'name': 'my-card-name',
            'due': '2022-05-05T09:45',
            'idMembers': [],
          }),
        ],
        testNotFound: false,
        testServerError: false,
        expected: CliExpectations(
          requests: [
            ExpectedRequest(
                expectedMethod: 'GET',
                expectedPath: '/1/cards/my-card-id',
                expectedHeaders: {},
                expectedQueryParameters: {'fields': 'idMembers'})
          ],
          output: [
            'ERROR: card remove-member - Failure: Can\'t Remove a Member from a Card as it is already applied'
          ],
          help: helpOutput,
        ));
  });
  group(
      'no member-id',
      () => cliTest(
          arguments: 'card remove-member my-card-id'.split(' '),
          responses: [],
          expected: CliExpectations(requests: [], output: [
            'ERROR: card remove-member - Failure: Member Id not given'
          ], help: helpOutput)));
  group(
      'no card-id, member-id',
      () => cliTest(
          arguments: 'card remove-member'.split(' '),
          responses: [],
          expected: CliExpectations(requests: [], output: [
            'ERROR: card remove-member - Failure: Card Id not given'
          ], help: helpOutput)));
}
