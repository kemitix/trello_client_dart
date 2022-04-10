class TrelloList {
  final dynamic _source;
  final List<ListFields> _fields;

  TrelloList(this._source, this._fields);

  String get id => _getValue(ListFields.id);
  String get name => _getValue(ListFields.name);
  bool get closed => _getValue(ListFields.closed);
  String get idBoard => _getValue(ListFields.idBoard);
  int get pos => _getValue(ListFields.pos);
  bool get subscribed => _getValue(ListFields.subscribed);

  T _getValue<T>(ListFields field) {
    if (_fields.contains(ListFields.all) || _fields.contains(field)) {
      return _source[field.name];
    }
    throw AssertionError(
        'List: Attempt to access field not retrieved: ${field.name}');
  }
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
