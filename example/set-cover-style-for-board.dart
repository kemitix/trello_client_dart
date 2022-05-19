#!/usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:trello_sdk/src/sdk/external/dio_client_factory.dart';
import 'package:trello_sdk/trello_cli.dart';

void main() async {
  // verify authentication properties
  var auth = authentication(Platform.environment);
  Either<Failure, TrelloClient> client = createClient(auth);

  // get list of boards the user has access to
  var boardList = (await Either.sequenceFuture(client.map((client) => client
          .member(MemberId(Platform.environment['TRELLO_USERNAME']!))
          .getBoards(
              fields: [BoardFields.id, BoardFields.name],
              filter: MemberBoardFilter.open))))
      .flatMap(id);

  // select board
  var selectedBoard = boardList.flatMap((list) => selectBoard(list));

  // ask user which cover style to apply
  var style =
      menu(prompt: 'Cover Style to apply?', options: ['normal', 'full']);

  var listOfLists = (await Either.sequenceFuture(map2either(
          client,
          selectedBoard,
          (TrelloClient client, TrelloBoard board) => getLists(client, board))))
      .flatMap(id);

  Either<Failure, List<TrelloCard>> cards = (await Either.sequenceFuture(
          map2either(
              client,
              listOfLists,
              (TrelloClient client, List<TrelloList> lists) async =>
                  await listOfCards(client, lists))))
      .flatMap(id);

  Either<Failure, List<TrelloCard>> updatedCards = await client
      .map((client) => cards.map((cards) => updateCards(cards, client, style)))
      .flatMap(id)
      .traverseFuture(id)
      .then((e) => e.flatMap(id));

  client.map((client) => client.close());

  updatedCards.fold(
      (l) => print('Error: $l'), (r) => print('Updated ${r.length} cards'));
}

Future<Either<Failure, List<TrelloCard>>> updateCards(
    List<TrelloCard> cards, TrelloClient client, String style) async {
  var result = <TrelloCard>[];
  for (var card in cards) {
    var updatedCard = await updateCard(client, card, style);
    if (updatedCard.isLeft()) return updatedCard.map((_) => []);
    updatedCard.map((card) => result.add(card));
  }
  return right(result);
}

Future<Either<Failure, TrelloCard>> updateCard(
        TrelloClient client, TrelloCard card, String style) =>
    client.card(card.id).put({
      'cover': {'size': style}
    });

Future<Either<Failure, List<TrelloCard>>> listOfCards(
    TrelloClient client, List<TrelloList> lists) async {
  var result = <TrelloCard>[];
  for (var list in lists) {
    Either<Failure, List<TrelloCard>> cards = await getCards(client, list);
    if (cards.isLeft()) return cards;
    cards.map((cards) => result.addAll(cards));
  }
  return right(result);
}

Future<Either<Failure, List<TrelloCard>>> getCards(
        TrelloClient client, TrelloList list) =>
    client.list(list.id).getCards(fields: [CardFields.id]);

Future<Either<Failure, List<TrelloList>>> getLists(
        TrelloClient client, TrelloBoard board) =>
    client.board(board.id).getLists(
        filter: ListFilter.all, fields: [ListFields.id, ListFields.name]);

Either<Failure, TrelloClient> createClient(
    Either<Errors, TrelloAuthentication> auth) {
  return auth
      .map((auth) => dioClientFactory(auth))
      .leftMap((errors) => AuthenticationFailure(errors));
}

class AuthenticationFailure extends Failure {
  AuthenticationFailure(Errors errors) : super(message: errors.join(', '));
}

Either<Failure, TrelloBoard> selectBoard(List<TrelloBoard> boardList) =>
    right<Failure, List<TrelloBoard>>(boardList)
        .filter((list) => list.isNotEmpty, () => MemberHasNoBoardsFailure())
        .map((boards) {
      var selectedBoard = menu(
          prompt: 'Select board',
          options: boardList.map((TrelloBoard board) => board.name).toList());
      return boards.where((board) => board.name == selectedBoard).first;
    });

class MemberHasNoBoardsFailure extends Failure {
  MemberHasNoBoardsFailure()
      : super(message: 'The user had no boards to select');
}
