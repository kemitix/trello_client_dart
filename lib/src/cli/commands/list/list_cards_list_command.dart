import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../trello_sdk.dart';
import 'list_module.dart';

class ListCardsCommand extends ListCommand {
  ListCardsCommand(TrelloClient client)
      : super('list-cards', 'Get Cards in a List', client);

  final List<CardFields> fields = [
    CardFields.id,
    CardFields.name,
    CardFields.pos,
    CardFields.due,
  ];

  @override
  FutureOr<void> run() async =>
      (await listId.map(listClient).map(getCards).unwrapFuture())
          .map((cards) => tabulateObjects(cards, fields))
          .collapse(printOutput);

  Future<Either<Failure, List<TrelloCard>>> getCards(ListClient listClient) =>
      listClient.getCards(fields: fields);

  ListClient listClient(ListId listId) => client.list(listId);
}
