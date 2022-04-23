import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../trello_sdk.dart';
import 'board_module.dart';

class ListListsCommand extends BoardCommand {
  ListListsCommand(TrelloClient client)
      : super('list-lists', 'Get Lists on a Board', client);

  final List<ListFields> fields = [
    ListFields.id,
    ListFields.name,
    ListFields.pos,
    ListFields.closed,
    ListFields.subscribed,
  ];

  @override
  FutureOr<void> run() async =>
      printOutput((await unwrapFuture(boardId.map(boardClient).map(getLists)))
          .map((lists) => tabulateObjects(lists, fields)));

  Future<Either<Failure, List<TrelloList>>> getLists(BoardClient boardClient) =>
      boardClient.getLists(fields: fields);

  BoardClient boardClient(BoardId boardId) => client.board(boardId);
}
