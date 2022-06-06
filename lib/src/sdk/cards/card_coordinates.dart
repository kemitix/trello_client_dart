import 'package:equatable/equatable.dart' show EquatableMixin;

// Field value may come from Trello as 'latitude,longitude'
class CardCoordinates with EquatableMixin {
  late double latitude;
  late double longitude;

  CardCoordinates({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}
