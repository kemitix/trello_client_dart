import 'package:meta/meta.dart';

abstract class TrelloObject<T extends Enum> {
  final dynamic _source;
  final List<T> _fields;
  late final bool _all; // were all fields selected'

  TrelloObject(this._source, this._fields, {all: bool}) {
    _all = all;
  }

  dynamic get raw => _source;

  @protected
  V getValue<V>(T field) {
    if (_all || _fields.contains(field)) {
      return _source[field.name];
    }
    throw AssertionError(
        'Attempt to access field not retrieved: ${field.name}');
  }

  @protected
  DateTime? toDateTime(String? value) {
    if (value == null) return null;
    return DateTime.parse(value);
  }
}
