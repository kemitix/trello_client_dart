import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/src/options.dart';
import 'package:test/test.dart';
import 'package:trello_sdk/src/sdk/cards/cards.dart';
import 'package:trello_sdk/src/sdk/errors.dart';
import 'package:trello_sdk/src/sdk/extensions/list_extensions.dart';
import 'package:trello_sdk/src/sdk/fp/fp_task_either.dart';
import 'package:trello_sdk/src/sdk/fp/fp_nullx.dart';

import '../../cli/cli_commons.dart';
import '../../mocks/dio_mock.dart';
import '../sdk_commons.dart';

void main() {
  //get
  group('get', () {
    group('exists', () {
      //given
      var cardId = 'my-card-id';
      var existingCardResponse = createResponse(body: {
        'id': 'my-card-id',
        'name': 'my-card-name',
      });
      var client = TestTrelloClient(responses: [existingCardResponse]);
      late final Either<Failure, TrelloCard> response;

      //when
      setUpAll(() async => response =
          await client.trelloClient.card(CardId(cardId)).get().run());

      //then
      group('request', () {
        var request;
        test('there was one request',
            () => expect(client.fetchHistory.length, 1));
        setUpAll(() {
          request = client.fetchHistory.head!.head;
        });
        test('got first request', () => expect(request, isNotNull));
        test('method', () => expect(request.method, 'GET'));
        test('path', () => expect(request.path, '/1/cards/my-card-id'));
        test(
            'query parameters',
            () => expect(request.queryParameters, {
                  'fields': 'all',
                }));
      });
      group('response', () {
        test(
            'card id',
            () => verify<TrelloCard>(
                response, (card) => expect(card.id, CardId(cardId))));
        test(
            'card name',
            () => verify<TrelloCard>(
                response, (card) => expect(card.name, 'my-card-name')));
      });
    });
    group('not found', () {
      //given
      var cardId = 'my-card-id';
      var missingCardResponse = createResponse(statusCode: 404, body: {});
      var client = TestTrelloClient(responses: [missingCardResponse]);
      late final Either<Failure, TrelloCard> response;

      //when
      setUpAll(() async => response =
          await client.trelloClient.card(CardId(cardId)).get().run());

      //then
      group('request', () {
        var request;
        test('there was one request',
            () => expect(client.fetchHistory.length, 1));
        setUpAll(() {
          request = client.fetchHistory.head!.head;
        });
        test('got first request', () => expect(request, isNotNull));
        test('method', () => expect(request.method, 'GET'));
        test('path', () => expect(request.path, '/1/cards/my-card-id'));
        test(
            'query parameters',
            () => expect(request.queryParameters, {
                  'fields': 'all',
                }));
      });
      group('response', () {
        test(
            'status code',
            () async => response.fold(
                  (l) => expect(
                      l.toString(),
                      ResourceNotFoundFailure(resource: '/1/cards/my-card-id')
                          .toString()),
                  (r) => fail('should have failed'),
                ));
      });
    });
  });
  //put
  //addMember
  //attachments
  //attachment
}
