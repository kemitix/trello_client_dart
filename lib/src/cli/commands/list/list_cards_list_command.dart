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
      (await Either.sequenceFuture(listId.map(listClient).map(getCards)))
          .flatMap(id)
          .map((cards) => tabulateObjects(cards, fields))
          .fold(
            (failure) => print('ERROR: ${parent!.name} $name - $failure'),
            (table) => print(table),
          );

  Future<Either<Failure, List<TrelloCard>>> getCards(ListClient listClient) =>
      listClient.getCards(fields: fields);

  ListClient listClient(ListId listId) => client.list(listId);
}
