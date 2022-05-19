#!/usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:trello_sdk/src/sdk/external/dio_client_factory.dart';
import 'package:trello_sdk/trello_cli.dart';

void main() async {
  var auth = authentication(Platform.environment);
  var client = createClient(auth);
  var memberId = MemberId(Platform.environment['TRELLO_USERNAME']!);
  var boards = await getMembersBoards(memberId, client);
  var board = selectBoard(boards);
  var lists = await getBoardLists(client, board);
  var cards = await getCardsOnLists(client, lists);
  var style =
      menu(prompt: 'Cover Style to apply?', options: ['normal', 'full']);
  var updatedCards = await updateAllCards(client, cards, style);
  closeClient(client);
  updatedCards.fold(
    (l) => print('Error: $l'),
    (r) => print('Updated ${r.length} cards'),
  );
}

Either<Failure, TrelloClient> createClient(
  Either<Errors, TrelloAuthentication> auth,
) =>
    auth
        .map((auth) => dioClientFactory(auth))
        .leftMap((errors) => AuthenticationFailure(errors));

Future<Either<Failure, List<TrelloBoard>>> getMembersBoards(
  MemberId memberId,
  Either<Failure, TrelloClient> client,
) async =>
    (await Either.sequenceFuture(client.map((client) => client
            .member(memberId)
            .getBoards(
                fields: [BoardFields.id, BoardFields.name],
                filter: MemberBoardFilter.open))))
        .flatMap(id);

Either<Failure, TrelloBoard> selectBoard(
  Either<Failure, List<TrelloBoard>> boardList,
) =>
    boardList.flatMap((list) => right<Failure, List<TrelloBoard>>(list)
            .filter(
          (list) => list.isNotEmpty,
          () => MemberHasNoBoardsFailure(),
        )
            .map((boards) {
          var selection =
              menu(prompt: 'Select board', options: boardNames(list));
          return boards.where((board) => board.name == selection).first;
        }));

List<String> boardNames(List<TrelloBoard> list) =>
    list.map((board) => board.name).toList();

Future<Either<Failure, List<TrelloList>>> getBoardLists(
  Either<Failure, TrelloClient> client,
  Either<Failure, TrelloBoard> selectedBoard,
) async =>
    (await Either.sequenceFuture(map2either(
            client,
            selectedBoard,
            (TrelloClient client, TrelloBoard board) => client
                .board(board.id)
                .getLists(
                    filter: ListFilter.all,
                    fields: [ListFields.id, ListFields.name]))))
        .flatMap(id);

Future<Either<Failure, List<TrelloCard>>> getCardsOnLists(
  Either<Failure, TrelloClient> client,
  Either<Failure, List<TrelloList>> boardLists,
) async =>
    (await Either.sequenceFuture(map2either(
            client,
            boardLists,
            (TrelloClient client, List<TrelloList> lists) async =>
                await listOfCards(client, lists))))
        .flatMap(id);

Future<Either<Failure, List<TrelloCard>>> listOfCards(
  TrelloClient client,
  List<TrelloList> lists,
) async {
  var result = <TrelloCard>[];
  for (var list in lists) {
    var cards = await getCards(client, list);
    if (cards.isLeft()) return cards;
    cards.map((cards) => result.addAll(cards));
  }
  return right(result);
}

Future<Either<Failure, List<TrelloCard>>> getCards(
  TrelloClient client,
  TrelloList list,
) =>
    client.list(list.id).getCards(fields: [CardFields.id]);

Future<Either<Failure, List<TrelloCard>>> updateAllCards(
  Either<Failure, TrelloClient> client,
  Either<Failure, List<TrelloCard>> boardCards,
  String style,
) =>
    client
        .map((client) =>
            boardCards.map((cards) => updateCards(cards, client, style)))
        .flatMap(id)
        .traverseFuture(id)
        .then((e) => e.flatMap(id));

Future<Either<Failure, List<TrelloCard>>> updateCards(
  List<TrelloCard> cards,
  TrelloClient client,
  String style,
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

Either<Failure, void> closeClient(Either<Failure, TrelloClient> client) =>
    client.map((client) => client.close());

class AuthenticationFailure extends Failure {
  AuthenticationFailure(Errors errors) : super(message: errors.join(', '));
}

class MemberHasNoBoardsFailure extends Failure {
  MemberHasNoBoardsFailure()
      : super(message: 'The user had no boards to select');
}
