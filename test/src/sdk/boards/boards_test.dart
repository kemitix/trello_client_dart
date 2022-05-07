import 'package:dartz/dartz.dart';
import 'package:test/test.dart';
import 'package:trello_sdk/src/sdk/boards/board_client.dart';
import 'package:trello_sdk/src/sdk/boards/board_models.dart';
import 'package:trello_sdk/src/sdk/errors.dart';
import 'package:trello_sdk/src/sdk/lists/list_models.dart';

import '../../cli/cli_commons.dart';
import '../../mocks/dio_mock.dart';
import '../sdk_commons.dart';

void main() {
  group('getLists', () {
    //given
    var boardId = 'my-board-id';
    var client = TestTrelloClient(responses: [
      createResponse(body: [
        {
          'id': 'my-list-id',
          'name': 'my-list-name',
          'closed': true,
          'idBoard': boardId,
          'pos': 2000,
          'subscribed': true,
        }
      ]),
    ]);
    var boardClient = client.trelloClient.board(BoardId(boardId));
    late Either<Failure, TrelloList> firstList;

    //when
    setUpAll(() async => firstList = await getFirstList(boardClient));

    //then
    test('board id', () async => verify<TrelloList>(firstList, (r) => expect(r.id, ListId('my-list-id'))));
    test('board name', () async => verify<TrelloList>(firstList, (r) => expect(r.name, 'my-list-name')));
    test('board closed', () async => verify<TrelloList>(firstList, (r) => expect(r.closed, true)));
    test('board idBoard', () async => verify<TrelloList>(firstList, (r) => expect(r.idBoard, BoardId(boardId))));
    test('board pos', () async => verify<TrelloList>(firstList, (r) => expect(r.pos, 2000)));
    test('board subscribed', () async => verify<TrelloList>(firstList, (r) => expect(r.subscribed, true)));
  });
}

Future<Either<Failure, TrelloList>> getFirstList(BoardClient boardClient) async =>
     boardClient.getLists().map((list) => list[0]).run();
