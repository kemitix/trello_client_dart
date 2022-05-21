#!/usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:trello_sdk/src/sdk/external/dio_client_factory.dart';
import 'package:trello_sdk/trello_cli.dart';

Future<void> main() async {
  var client = createClient(authentication(Platform.environment));
  client.map((client) async {
    var boards = await getMembersBoards(member(), client);
    var board = selectBoard(boards);
    await Either.sequenceFuture(board.map((board) async {
      var lists = await getLists(board, client);
      var cards = await getCardsOnLists(lists, client);
      var updatedCards = await updateAllCards(cards, selectStyle(), client);
      return updatedCards;
    })).then(printSummary);
    client.close();
  });
}

void printSummary(Either<Failure, List<TrelloCard>> cards) => cards.fold(
      (l) => print('Error: $l'),
      (r) => print('Updated ${r.length} cards'),
    );

String selectStyle() =>
    menu(prompt: 'Cover Style to apply?', options: ['normal', 'full']);

MemberId member() => MemberId(Platform.environment['TRELLO_USERNAME']!);

Either<Failure, TrelloClient> createClient(
  Either<Errors, TrelloAuthentication> auth,
) =>
    auth
        .map((auth) => dioClientFactory(auth))
        .leftMap((errors) => AuthenticationFailure(errors));

Future<List<TrelloBoard>> getMembersBoards(
  MemberId memberId,
  TrelloClient client,
) async =>
    client.member(memberId).getBoards(
        fields: [BoardFields.id, BoardFields.name],
        filter: MemberBoardFilter.open);

Either<Failure, TrelloBoard> selectBoard(List<TrelloBoard> boardList) =>
    right<Failure, List<TrelloBoard>>(boardList)
        .filter(
      (list) => list.isNotEmpty,
      () => MemberHasNoBoardsFailure(),
    )
        .map((boards) {
      var selection =
          menu(prompt: 'Select board', options: boardNames(boardList));
      return boards.where((board) => board.name == selection).first;
    });

List<String> boardNames(List<TrelloBoard> list) =>
    list.map((board) => board.name).toList();

Future<List<TrelloList>> getLists(
  TrelloBoard board,
  TrelloClient client,
) async =>
    client.board(board.id).getLists(
        filter: ListFilter.all, fields: [ListFields.id, ListFields.name]);

Future<List<TrelloCard>> getCardsOnLists(
  List<TrelloList> lists,
  TrelloClient client,
) {
  var result = <TrelloCard>[];
  return Future.forEach(
          lists,
          (TrelloList list) =>
              getCards(list, client).then((cards) => result.addAll(cards)))
      .then((_) => result);
}

Future<List<TrelloCard>> getCards(
  TrelloList list,
  TrelloClient client,
) =>
    client.list(list.id).getCards(fields: [CardFields.id]);

Future<List<TrelloCard>> updateAllCards(
  List<TrelloCard> cards,
  String style,
  TrelloClient client,
) async {
  var result = <TrelloCard>[];
  return Future.forEach(
      cards,
      (TrelloCard card) => updateCard(client, card, style)
          .then((updatedCard) => result.add(updatedCard))).then((_) => result);
}

Future<TrelloCard> updateCard(
  TrelloClient client,
  TrelloCard card,
  String style,
) =>
    client.card(card.id).put({
      'cover': {'size': style}
    });

class AuthenticationFailure extends Failure {
  AuthenticationFailure(Errors errors) : super(message: errors.join(', '));
}

class MemberHasNoBoardsFailure extends Failure {
  MemberHasNoBoardsFailure()
      : super(message: 'The user had no boards to select');
}
