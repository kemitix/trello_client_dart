import 'package:trello_client/src/boards.dart';

class TrelloList {
  final dynamic _source;
  final List<ListFields> _fields;

  TrelloList(this._source, this._fields);

  String get id => _getValue(ListFields.id);
  String get name => _getValue(ListFields.name);

  T _getValue<T>(ListFields field) {
    if (_fields.contains(ListFields.all) || _fields.contains(field)) {
      return _source[field.name];
    }
    throw AssertionError(
        'List: Attempt to access field not retrieved: ${field.name}');
  }
}
