import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:trello_sdk/src/cli/app.dart';
import 'package:trello_sdk/src/sdk/client.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../../../mocks/dio_mock.dart';
import '../../cli_commons.dart';

void main() {
  //given
  var cardId = 'my-card-id';
  var attachmentId = 'my-attachment-id';
  var fileName = 'my-file-name';
  var attachmentResult = {'url': 'my-url', 'bytes': 2};
  var attachmentResponse = createResponse(body: attachmentResult);
  var fileContent = '{file: "content"}';
  var fileContentResponse = createResponse(body: fileContent);
  var client = TestTrelloClient(responses: [
    attachmentResponse,
    fileContentResponse,
  ]);
  var printer = FakePrinter();
  var environment = EnvArgsEnvironment(
    platformEnvironment: validEnvironment,
    arguments:
        'card download-attachment $cardId $attachmentId $fileName'.split(' '),
    clientFactory: (_) => client.trelloClient,
    printer: printer.printer,
  );

  //when
  setUpAll(() => app().run(environment));

  //then
  var history = client.fetchHistory;
  test('there were two API calls', () => expect(history.length, 2));
  test('first request was a GET', () => expect(history[0].head.method, 'GET'));
  test(
      'first request path',
      () => expect(
          history[0].head.path, '/1/cards/$cardId/attachments/$attachmentId'));
  test('first request has no query parameters',
      () => expect(history[0].head.queryParameters, {}));
  test('second request was a GET', () => expect(history[1].head.method, 'GET'));
  test('second request has no base URL',
      () => expect(history[1].head.baseUrl, ''));
  test('second request path', () => expect(history[1].head.path, 'my-url'));
  test(
      'output',
      () async => expect(printer.output, [
            'Download complete',
          ]));
  test('one file written', () async => expect(client.filesWritten.length, 1));
  test('write to correct file',
      () async => expect(client.filesWritten[0].head, FileName(fileName)));
  test(
      'write correct file content',
      () async => expect(
          String.fromCharCodes(client.filesWritten[0].tail), fileContent));
}
