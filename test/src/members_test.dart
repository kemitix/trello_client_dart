import 'package:test/test.dart';
import 'package:trello_client/src/boards.dart';
import 'package:trello_client/src/models/models.dart';

void main() {
  test('BoardFields to enum CSV is format', () {
    //given
    List<BoardFields> fields = [BoardFields.id, BoardFields.name];
    //when
    String csv = boardFieldsToCsv(fields);
    //then
    expect(csv, 'id,name');
  });
}
