import '../../../sdk/sdk_commons.dart';
import '../../cli_commons.dart';

void main() {
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
      help: [
        'Get an Attachment on a Card',
        '',
        'Usage: trello card get-attachment [arguments]',
        '-h, --help      Print this usage information.',
        '    --fields    all or a comma-separated list of fields',
        '                (defaults to "id,name,mimeType,bytes,url")',
        '',
        'Run "trello help" to see global options.'
      ],
      notFoundOutput: [
        'ERROR: card get-attachment - Failure: Resource not found: /1/cards/my-card-id/attachments/my-attachment-id'
      ],
      serverErrorOutput: [
        'ERROR: card get-attachment - Failure: GET /1/cards/my-card-id/attachments/my-attachment-id'
      ],
    ),
  );
}
