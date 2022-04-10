import 'package:test/test.dart';
import 'package:trello_client/src/misc.dart';
import 'package:trello_client/src/models/models.dart';

void main() {
  test('List of enum CSV is format', () {
    //given
    List<BoardFields> fields = [BoardFields.id, BoardFields.name];
    //when
    String csv = listEnumToCsv(fields);
    //then
    expect(csv, 'id,name');
  });
}
