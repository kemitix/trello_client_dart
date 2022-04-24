import 'package:test/test.dart';
import 'package:trello_sdk/trello_sdk.dart';

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
