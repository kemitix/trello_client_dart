import 'package:trello_client/src/models/models.dart';

String boardFieldsToCsv(List<BoardFields> fields) {
  List<String> output = [];
  fields.map((field) => field.name).forEach(output.add);
  return output.join(',');
}
