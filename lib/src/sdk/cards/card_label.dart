import 'package:equatable/equatable.dart' show EquatableMixin;

class CardLabel with EquatableMixin {
  late String id;
  late String idBoard;
  late String name;
  late String color;

  CardLabel(this.id, this.idBoard, this.name, this.color);

  @override
  List<Object?> get props => [id, idBoard, name, color];
}
