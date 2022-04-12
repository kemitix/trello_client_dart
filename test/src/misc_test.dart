import 'package:test/test.dart';
import 'package:trello_client/src/boards/boards.dart';
import 'package:trello_client/src/misc.dart';

void main() {
  test('List of enum CSV is format', () {
    //given
    List<BoardFields> fields = [BoardFields.id, BoardFields.name];
    //when
    String csv = asCsv(fields);
    //then
    expect(csv, 'id,name');
  });
}
