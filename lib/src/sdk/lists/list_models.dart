import '../boards/boards.dart' show BoardId;
import '../client.dart' show StringValue;
import '../trello_object.dart' show TrelloObject;

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

class ListId extends StringValue {
  ListId(id) : super(id);
}

enum ListFields {
  all,
  id,
  name,
  closed,
  idBoard,
  pos,
  subscribed,
}

enum ListFilter {
  all,
  closed,
  none,
  open,
}
