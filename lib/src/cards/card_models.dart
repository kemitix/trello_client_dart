class Card {
  final dynamic _source;
  final List<CardFields> _fields;

  Card(this._source, this._fields);

  String get id => _getValue(CardFields.id);
  String get name => _getValue(CardFields.name);

  T _getValue<T>(CardFields field) {
    if (_fields.contains(CardFields.all) || _fields.contains(field)) {
      return _source[field.name];
    }
    throw AssertionError(
        'List: Attempt to access field not retrieved: ${field.name}');
  }
}

enum CardFields {
  all,
  id,
  name,
  //TODO more
}
