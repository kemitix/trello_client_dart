import 'package:test/test.dart';

import '../../../sdk/sdk_commons.dart';
import '../../cli_commons.dart';

void main() {
  var helpOutput = [
    'List Attachments on a Card',
    '',
    'Usage: trello card list-attachments [arguments]',
    '-h, --help      Print this usage information.',
    '    --fields    all or a comma-separated list of fields',
    '                (defaults to "id,name,mimeType,bytes")',
    '',
    'Run "trello help" to see global options.'
  ];
  cliTest(
    arguments: 'card list-attachments my-card-id'.split(' '),
    responses: [
      createResponse(body: [
        {
          'id': 'my-card-id',
          'name': 'my-card-name',
          'mimeType': 'my-mime-type',
          'bytes': 100,
        }
      ])
    ],
    expected: CliExpectations(
      requests: [
        ExpectedRequest(
          expectedMethod: 'GET',
          expectedPath: '/1/cards/my-card-id/attachments',
          expectedHeaders: {
            'Authorization':
                'OAuth oauth_consumer_key="_key", oauth_token="_token"'
          },
          expectedQueryParameters: {
            'filter': 'false',
            'fields': 'id,name,mimeType,bytes'
          },
        ),
      ],
      output: [
        'id         | name         | mimeType     | bytes',
        '-----------|--------------|--------------|------',
        'my-card-id | my-card-name | my-mime-type |   100',
      ],
      help: helpOutput,
      notFoundOutput: [
        'ERROR: card list-attachments - Failure: Resource not found: /1/cards/my-card-id/attachments'
      ],
      serverErrorOutput: [
        'ERROR: card list-attachments - Failure: GET /1/cards/my-card-id/attachments'
      ],
    ),
  );
  group(
      'no card-id',
      () => cliTest(
          arguments: 'card list-attachments'.split(' '),
          responses: [],
          expected: CliExpectations(requests: [], output: [
            'ERROR: card list-attachments - Failure: Card Id not given'
          ], help: helpOutput)));
}
