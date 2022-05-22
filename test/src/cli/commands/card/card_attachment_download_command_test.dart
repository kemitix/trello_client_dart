import 'package:test/test.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../../../mocks/dio_mock.dart';
import '../../../sdk/sdk_commons.dart';
import '../../cli_commons.dart';

void main() {
  cliTest(
    arguments:
        'card download-attachment my-card-id my-attachment-id my-file-name'
            .split(' '),
    expectedRequests: [
      ExpectedRequest(
          expectedMethod: 'GET',
          expectedPath: '/1/cards/my-card-id/attachments/my-attachment-id',
          expectedHeaders: {},
          expectedQueryParameters: {}),
      ExpectedRequest(
          expectedMethod: 'GET',
          expectedPath: 'my-download-url',
          expectedHeaders: {
            'Authorization':
                'OAuth oauth_consumer_key="_key", oauth_token="_token"'
          },
          expectedQueryParameters: {}),
    ],
    responses: [
      createResponse(body: {'url': 'my-download-url'}),
      createResponse(body: {}),
    ],
    expectedOutput: ['Download complete'],
    expectedHelp: [
      'Download an Attachment file',
      '',
      'Usage: trello card download-attachment [arguments]',
      '-h, --help    Print this usage information.',
      '',
      'Run "trello help" to see global options.'
    ],
    expectedNotFoundOutput: [
      'ERROR: card download-attachment - Failure: Resource not found: /1/cards/my-card-id/attachments/my-attachment-id'
    ],
    expectedServerErrorOutput: [
      'ERROR: card download-attachment - Failure: GET /1/cards/my-card-id/attachments/my-attachment-id'
    ],
  );
  group('file download', () {
    //given
    var client = TestTrelloClient(responses: [
      (createResponse(body: {'url': 'my-url', 'bytes': 2})),
      (createResponse(body: '{file: "content"}')),
    ]);
    var printer = FakePrinter();
    var environment = EnvArgsEnvironment(
      platformEnvironment: validEnvironment,
      arguments:
          'card download-attachment my-card-id my-attachment-id my-file-name'
              .split(' '),
      clientFactory: (_) => client.trelloClient,
      printer: printer.printer,
    );

    //when
    setUpAll(() => app().run(environment));

    //then
    test('one file written', () async => expect(client.filesWritten.length, 1));
    test(
        'write to correct file',
        () async =>
            expect(client.filesWritten[0].head, FileName('my-file-name')));
    test(
        'write correct file content',
        () async => expect(String.fromCharCodes(client.filesWritten[0].tail),
            '{file: "content"}'));
  });
}
