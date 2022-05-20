#!/usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:trello_sdk/src/sdk/external/dio_client_factory.dart';
import 'package:trello_sdk/trello_cli.dart';

const m1efm = map1eitherFM;
const d1e1 = defer1either1;
const d1e2 = defer1either2;

void main() => createClient(authentication(Platform.environment)).map(
    (client) => getMembersBoards(member(), client)
        .then((boards) => m1efm(boards, selectBoard))
        .then((board) => d1e1(board, client, getLists))
        .then((lists) => d1e1(lists, client, getCardsOnLists))
        .then((cards) => d1e2(cards, selectStyle(), client, updateAllCards))
        .then((cards) => printSummary(cards))
        .whenComplete(() => client.close()));

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

Future<Either<Failure, List<TrelloBoard>>> getMembersBoards(
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

Future<Either<Failure, List<TrelloList>>> getLists(
  TrelloBoard board,
  TrelloClient client,
) async =>
    client.board(board.id).getLists(
        filter: ListFilter.all, fields: [ListFields.id, ListFields.name]);

Future<Either<Failure, List<TrelloCard>>> getCardsOnLists(
  List<TrelloList> lists,
  TrelloClient client,
) async {
  var result = <TrelloCard>[];
  for (var list in lists) {
    var cards = await getCards(list, client);
    if (cards.isLeft()) return cards;
    cards.map((cards) => result.addAll(cards));
  }
  return right(result);
}

Future<Either<Failure, List<TrelloCard>>> getCards(
  TrelloList list,
  TrelloClient client,
) =>
    client.list(list.id).getCards(fields: [CardFields.id]);

Future<Either<Failure, List<TrelloCard>>> updateAllCards(
  List<TrelloCard> cards,
  String style,
  TrelloClient client,
) async {
  var result = <TrelloCard>[];
  for (var card in cards) {
    var updatedCard = await updateCard(client, card, style);
    if (updatedCard.isLeft()) return updatedCard.map((_) => []);
    updatedCard.map((card) => result.add(card));
  }
  return right(result);
}

Future<Either<Failure, TrelloCard>> updateCard(
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
