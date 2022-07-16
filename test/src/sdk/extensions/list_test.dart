import 'package:test/test.dart';
import 'package:trello_client/trello_sdk.dart';

void main() {
  test('list.head returns first item on list', () {
    //given
    var list = <String>['hello', 'world'];
    //when
    String? result = list.head;
    //then
    expect(result, 'hello');
  });
  test('list.head return null on empty list', () {
    //given
    var list = <String>[];
    //when
    String? result = list.head;
    //then
    expect(result, isNull);
  });
}
