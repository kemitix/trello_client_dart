import 'package:meta/meta.dart';

abstract class TrelloObject<T extends Enum> {
  final Map<String, dynamic> _source;
  final List<T> _fields;
  late final bool _all; // were all fields selected'

  TrelloObject(this._source, this._fields, {bool all = true}) {
    _all = all;
  }

  Map<String, dynamic> toJson() => raw;

  Map<String, dynamic> get raw => _source;

  List<T> get fields => _fields;

  //@protected
  V getValue<V>(T field) {
    String fieldName = field.name;
    if (_all || _fields.contains(field)) {
      if (_source.keys.contains(fieldName)) {
        return _source[fieldName];
      }
    }
    throw AssertionError('Attempt to access field not retrieved: $fieldName');
  }

  List<String> getValueAsListString(T field) =>
      (getValue(field) as List<dynamic>)
          .map((value) => value.toString())
          .toList();

  @protected
  DateTime? toDateTime(String? value) {
    if (value == null) return null;
    return DateTime.parse(value);
  }
}
