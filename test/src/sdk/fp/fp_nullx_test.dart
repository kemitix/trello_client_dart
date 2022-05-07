import 'package:test/test.dart';

import 'package:dartz/dartz.dart';

import 'package:trello_sdk/src/sdk/fp/fp_nullx.dart';

void main() {
  final String? null_value = null;
  final String? a_value = "Hello, World!";
  group('toOption', () {
    test('when null', () => expect(null_value.toOption(), none()));
    test('when not null', () => expect(a_value.toOption(), some(a_value)));
  });
  group('toEither', () {
    test('when null',
        () => expect(null_value.toEither(() => ('is null')), left('is null')));
    test('when not null',
        () => expect(a_value.toEither(() => ('is null')), right(a_value)));
  });
  group('toList', () {
    test('when null', () => expect(null_value.toList(), []));
    test('when not null', () => expect(a_value.toList(), [a_value!]));
  });
  group('toIterable', () {
    test('when null', () => expect(null_value.toIterable().isEmpty, isTrue));
    test('when not null contains value',
        () => expect(a_value.toIterable().contains(a_value!), isTrue));
    test('when not null has no other value',
        () => expect(a_value.toIterable().length, 1));
  });
  group('toStream', () {
    test('when null',
        () async => expect(await null_value.toStream().toList(), []));
    test('when not null',
        () async => expect(await a_value.toStream().toList(), [a_value!]));
  });
}
