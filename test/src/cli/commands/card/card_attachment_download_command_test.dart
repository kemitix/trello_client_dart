import 'package:test/test.dart';
import 'package:trello_sdk/src/cli/app.dart';
import 'package:trello_sdk/src/sdk/client.dart';

import '../../cli_commons.dart';

void main() {
  var cardId = 'my-card-id';
  var attachmentId = 'my-attachment-id';
  var fileName = 'my-file-name';
  var attachmentResult = {'url': 'my-url', 'bytes': 2};
  var attachmentResponse = createResponse(body: attachmentResult);
  var fileContentResponse = createResponse(body: 'file content');
  var fakeTrelloClient = createFakeTrelloClient([
    attachmentResponse,
    fileContentResponse,
  ]);
  var fetchHistory = fakeTrelloClient.fetchHistory;
  setUpAll(() async => await app().run(EnvArgsEnvironment(
      validEnvironment,
      'card download-attachment $cardId $attachmentId $fileName'.split(' '),
      (TrelloAuthentication _) => fakeTrelloClient.trelloClient)));
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
  //TODO test correct output is written to the correct file
}
