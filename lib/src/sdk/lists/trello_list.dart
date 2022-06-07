import '../boards/boards.dart' show BoardId;
import '../trello_object.dart' show TrelloObject;
import 'list_fields.dart' show ListFields;
import 'list_id.dart' show ListId;

class TrelloList extends TrelloObject<ListFields> {
  TrelloList(source, List<ListFields> fields)
      : super(source, fields, all: fields.contains(ListFields.all));

  ListId get id => ListId(getValue(ListFields.id));

  String get name => getValue(ListFields.name);

  bool get closed => getValue(ListFields.closed);

  BoardId get idBoard => BoardId(getValue(ListFields.idBoard));

  int get pos => getValue(ListFields.pos);

  bool get subscribed => getValue(ListFields.subscribed);
}
