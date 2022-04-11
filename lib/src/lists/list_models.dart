import '../trello_object_model.dart';

class TrelloList extends TrelloObject<ListFields> {
  TrelloList(source, List<ListFields> fields)
      : super(source, fields, all: fields.contains(ListFields.all));

  String get id => getValue(ListFields.id);
  String get name => getValue(ListFields.name);
  bool get closed => getValue(ListFields.closed);
  String get idBoard => getValue(ListFields.idBoard);
  int get pos => getValue(ListFields.pos);
  bool get subscribed => getValue(ListFields.subscribed);
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
