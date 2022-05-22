import 'package:test/test.dart';

import '../../../sdk/sdk_commons.dart';
import '../../cli_commons.dart';

void main() {
  var helpOutput = [
    'Get a Card',
    '',
    'Usage: trello card get [arguments]',
    '-h, --help      Print this usage information.',
    '    --fields    all or a comma-separated list of fields',
    '                (defaults to "id,name,pos,due,idMembers")',
    '',
    'Run "trello help" to see global options.'
  ];
  cliTest(
    arguments: 'card get my-card-id'.split(' '),
    responses: [
      createResponse(body: {
        'id': 'my-card-id',
        'pos': 'my-pos',
        'name': 'my-card-name',
        'due': '2022-05-05T09:45',
        'idMembers': ['my-member-id'],
      })
    ],
    expectations: CliExpectations(
      requests: [
        ExpectedRequest(
          expectedMethod: 'GET',
          expectedPath: '/1/cards/my-card-id',
          expectedHeaders: {},
          expectedQueryParameters: {'fields': 'id,name,pos,due,idMembers'},
        ),
      ],
      output: [
        'id        | my-card-id      ',
        'name      | my-card-name    ',
        'pos       | my-pos          ',
        'due       | 2022-05-05T09:45',
        'idMembers | [my-member-id]  ',
      ],
      help: helpOutput,
      notFoundOutput: [
        'ERROR: card get - Failure: Resource not found: /1/cards/my-card-id'
      ],
      serverErrorOutput: ['ERROR: card get - Failure: GET /1/cards/my-card-id'],
    ),
  );
  group(
      'no card-id',
      () => cliTest(
          arguments: 'card get'.split(' '),
          responses: [],
          expectations: CliExpectations(
              requests: [],
              output: ['ERROR: card get - Failure: Card Id not given'],
              help: helpOutput)));
}
