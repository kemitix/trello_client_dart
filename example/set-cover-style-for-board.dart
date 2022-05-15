#!/usr/bin/env dcli

import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:dcli/dcli.dart';
import 'package:trello_sdk/src/sdk/external/dio_client_factory.dart';
import 'package:trello_sdk/trello_cli.dart';

void main() async {
  // verify authentication properties
  var auth = authentication(Platform.environment);
  var client = createClient(auth);

  // get list of boards the user has access to
  var boardList = TaskEither.sequence(client.map((client) => getBoards(client)));

  // select board
  var selectedBoard = boardList.flatMap((boardList) => selectBoard(boardList));

  // ask user which cover style to apply
  var style = ask( 'Cover Style to apply?', validator: Ask.inList(['normal', 'full']));

  var lists = selectedBoard.flatMap((board) => TaskEither.sequence(client.map((client) => getLists(client, board))));

  // TaskEither<Failure, List<TaskEither<Failure, List<TrelloCard>>>>
  var cards =
  lists.map((lists) =>
      lists.map((TrelloList list) =>
          TaskEither.sequence(client.map((client) => getCards(client, list)))).toList(growable: false));

}

TaskEither<Failure, List<TrelloCard>> getCards(TrelloClient client, TrelloList list) => client.list(list.id).getCards(fields: [CardFields.id]);

TaskEither<Failure, List<TrelloList>> getLists(TrelloClient client, TrelloBoard board) => client.board(board.id).getLists(filter: ListFilter.all, fields: [ListFields.id, ListFields.name]);

TaskEither<Failure, List<TrelloBoard>> getBoards(TrelloClient client) {
  return client.member(MemberId(Platform.environment['TRELLO_USERNAME']!))
    .getBoards(fields: [BoardFields.id, BoardFields.name],   filter: MemberBoardFilter.open);
}

Either<Failure, TrelloClient> createClient(Either<Errors, TrelloAuthentication> auth) {
  return auth.map((auth) => dioClientFactory(auth))
    .leftMap((errors) => AuthenticationFailure(errors));
}

class AuthenticationFailure extends Failure {
  AuthenticationFailure(Errors errors): super(message: errors.join(', '));
}

TaskEither<Failure, TrelloBoard> selectBoard(List<TrelloBoard> boardList) {
  if (boardList.isEmpty) return TaskEither.left(MemberHasNoBoardsFailure());
  List<String> boardNames = boardList.map((TrelloBoard board) => board.name).toList();
  String boardName = menu(prompt: 'Select board', options: boardNames);
  TrelloBoard selectedBoard = boardList.where((board) => board.name == boardName).toList().first;
  return TaskEither.right(selectedBoard);
}

class MemberHasNoBoardsFailure extends Failure {
  MemberHasNoBoardsFailure(): super(message: 'The user had no boards to select');
}
