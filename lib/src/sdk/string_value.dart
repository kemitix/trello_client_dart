import 'package:equatable/equatable.dart' show EquatableMixin;

abstract class StringValue with EquatableMixin {
  final String value;

  StringValue(this.value);

  @override
  List<Object?> get props => [value];

  @override
  String toString() {
    return value;
  }
}
