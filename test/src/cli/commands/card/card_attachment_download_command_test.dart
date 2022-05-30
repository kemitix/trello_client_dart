import 'package:test/test.dart' show expect, group, setUpAll, test;
import 'package:trello_sdk/trello_cli.dart' show EnvArgsEnvironment, app;
import 'package:trello_sdk/trello_sdk.dart' show FileName;

import '../../../mocks/dio_mock.dart' show TestTrelloClient;
import '../../../sdk/sdk_commons.dart' show ExpectedRequest;
import '../../cli_commons.dart'
    show
        CliExpectations,
        FakePrinter,
        cliTest,
        createResponse,
        validEnvironment;

void main() {
  var helpOutput = [
    'Download an Attachment file',
    '',
    'Usage: trello card download-attachment [arguments]',
    '-h, --help    Print this usage information.',
    '',
    'Run "trello help" to see global options.'
  ];
  cliTest(
    arguments:
        'card download-attachment my-card-id my-attachment-id my-file-name'
            .split(' '),
    responses: [
      createResponse(body: {'url': 'my-download-url'}),
      createResponse(body: {}),
    ],
    expectations: CliExpectations(
      requests: [
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
      output: ['Download complete'],
      help: helpOutput,
      notFoundOutput: [
        'ERROR: card download-attachment - Failure: Resource not found: /1/cards/my-card-id/attachments/my-attachment-id'
      ],
      serverErrorOutput: [
        'ERROR: card download-attachment - Failure: GET /1/cards/my-card-id/attachments/my-attachment-id'
      ],
    ),
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
  group(
      'no file-name',
      () => cliTest(
          arguments:
              'card download-attachment my-card-id my-attachment-id'.split(' '),
          responses: [],
          expectations: CliExpectations(requests: [], output: [
            'ERROR: card download-attachment - Failure: File name not given'
          ], help: helpOutput)));
  group(
      'no attachment-id, file-name',
      () => cliTest(
          arguments: 'card download-attachment my-card-id'.split(' '),
          responses: [],
          expectations: CliExpectations(requests: [], output: [
            'ERROR: card download-attachment - Failure: Attachment Id not given'
          ], help: helpOutput)));
  group(
      'no card-id, attachment-id, file-name',
      () => cliTest(
          arguments: 'card download-attachment'.split(' '),
          responses: [],
          expectations: CliExpectations(requests: [], output: [
            'ERROR: card download-attachment - Failure: Card Id not given'
          ], help: helpOutput)));
}
