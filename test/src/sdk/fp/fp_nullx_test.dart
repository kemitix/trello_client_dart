import 'package:dartz/dartz.dart';
import 'package:test/test.dart';
import 'package:trello_sdk/src/sdk/fp/fp_nullx.dart';

void main() {
  final String? nullValue = null;
  final String? aValue = "Hello, World!";
  group('toOption', () {
    test('when null', () => expect(nullValue.toOption(), none()));
    test('when not null', () => expect(aValue.toOption(), some(aValue)));
  });
  group('toEither', () {
    test('when null',
        () => expect(nullValue.toEither(() => ('is null')), left('is null')));
    test('when not null',
        () => expect(aValue.toEither(() => ('is null')), right(aValue)));
  });
  group('toList', () {
    test('when null', () => expect(nullValue.toList(), []));
    test('when not null', () => expect(aValue.toList(), [aValue!]));
  });
  group('toIterable', () {
    test('when null', () => expect(nullValue.toIterable().isEmpty, isTrue));
    test('when not null contains value',
        () => expect(aValue.toIterable().contains(aValue!), isTrue));
    test('when not null has no other value',
        () => expect(aValue.toIterable().length, 1));
  });
  group('toStream', () {
    test('when null',
        () async => expect(await nullValue.toStream().toList(), []));
    test('when not null',
        () async => expect(await aValue.toStream().toList(), [aValue!]));
  });
}
