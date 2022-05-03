import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:trello_sdk/src/cli/app.dart';
import 'package:trello_sdk/src/sdk/client.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../../cli_commons.dart';

void main() {
  var cardId = 'my-card-id';
  var attachmentId = 'my-attachment-id';
  var fileName = 'my-file-name';
  var attachmentResult = {'url': 'my-url', 'bytes': 2};
  var attachmentResponse = createResponse(body: attachmentResult);
  var fileContent = '{file: "content"}';
  var fileContentResponse = createResponse(body: fileContent);
  var fakeTrelloClient = createFakeTrelloClient([
    attachmentResponse,
    fileContentResponse,
  ]);
  var fetchHistory = fakeTrelloClient.fetchHistory;
  var fakePrinter = FakePrinter();
  setUpAll(() async => await app().run(EnvArgsEnvironment(
      validEnvironment,
      'card download-attachment $cardId $attachmentId $fileName'.split(' '),
      (_) => fakeTrelloClient.trelloClient,
      fakePrinter.printer)));
  test('there were two API calls', () => expect(fetchHistory.length, 2));
  test('first request was a GET',
      () => expect(fetchHistory[0].head.method, 'GET'));
  test(
      'first request path',
      () => expect(fetchHistory[0].head.path,
          '/1/cards/$cardId/attachments/$attachmentId'));
  test('first request has no query parameters',
      () => expect(fetchHistory[0].head.queryParameters, {}));
  test('second request was a GET',
      () => expect(fetchHistory[1].head.method, 'GET'));
  test('second request has no base URL',
      () => expect(fetchHistory[1].head.baseUrl, ''));
  test(
      'second request path', () => expect(fetchHistory[1].head.path, 'my-url'));
  test(
      'output',
      () async => expect(fakePrinter.output, [
            'Download complete',
          ]));
  test('one file written',
      () async => expect(fakeTrelloClient.filesWritten.length, 1));
  test(
      'write to correct file',
      () async =>
          expect(fakeTrelloClient.filesWritten[0].head, FileName(fileName)));
  test(
      'write correct file content',
      () async => expect(
          String.fromCharCodes(fakeTrelloClient.filesWritten[0].tail),
          fileContent));
}
