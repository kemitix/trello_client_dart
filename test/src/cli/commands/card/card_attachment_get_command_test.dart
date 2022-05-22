import 'package:test/test.dart';

import '../../../sdk/sdk_commons.dart';
import '../../cli_commons.dart';

void main() {
  var helpOutput = [
    'Get an Attachment on a Card',
    '',
    'Usage: trello card get-attachment [arguments]',
    '-h, --help      Print this usage information.',
    '    --fields    all or a comma-separated list of fields',
    '                (defaults to "id,name,mimeType,bytes,url")',
    '',
    'Run "trello help" to see global options.'
  ];
  cliTest(
    arguments: 'card get-attachment my-card-id my-attachment-id'.split(' '),
    responses: [
      createResponse(body: {
        'id': 'my-card-id',
        'name': 'my-card-name',
        'mimeType': 'my-mime-type',
        'bytes': 100,
        'url': 'my-url',
      }),
    ],
    expected: CliExpectations(
      requests: [
        ExpectedRequest(
          expectedMethod: 'GET',
          expectedPath: '/1/cards/my-card-id/attachments/my-attachment-id',
          expectedHeaders: {},
          expectedQueryParameters: {},
        ),
      ],
      output: [
        'id       | my-card-id  ',
        'name     | my-card-name',
        'mimeType | my-mime-type',
        'bytes    | 100         ',
        'url      | my-url      ',
      ],
      help: helpOutput,
      notFoundOutput: [
        'ERROR: card get-attachment - Failure: Resource not found: /1/cards/my-card-id/attachments/my-attachment-id'
      ],
      serverErrorOutput: [
        'ERROR: card get-attachment - Failure: GET /1/cards/my-card-id/attachments/my-attachment-id'
      ],
    ),
  );
  group(
      'no attachment-id',
      () => cliTest(
          arguments: 'card get-attachment my-card-id'.split(' '),
          responses: [],
          expected: CliExpectations(requests: [], output: [
            'ERROR: card get-attachment - Failure: Attachment Id not given'
          ], help: helpOutput)));
  group(
      'no card-id, attachment-id',
      () => cliTest(
          arguments: 'card get-attachment'.split(' '),
          responses: [],
          expected: CliExpectations(requests: [], output: [
            'ERROR: card get-attachment - Failure: Card Id not given'
          ], help: helpOutput)));
}
