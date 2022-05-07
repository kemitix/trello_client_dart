import 'package:test/test.dart';
import 'package:trello_sdk/src/cli/app.dart';

import '../mocks/dio_mock.dart';
import 'cli_commons.dart';

void main() {
  group('environment errors', () {
    //given
    var invalidEnvironment = <String, String>{};

    var printer = FakePrinter();
    var envArgsEnvironment = EnvArgsEnvironment(
        platformEnvironment: invalidEnvironment,
        arguments: [],
        clientFactory: (_) => TestTrelloClient(responses: []).trelloClient,
        printer: printer.printer);
    //when
    setUpAll(() async => await app().run(envArgsEnvironment));
    //then
    test(
        'output',
        () => expect(printer.output, [
              'Environment not set TRELLO_USERNAME',
              'Environment not set TRELLO_KEY',
              'Environment not set TRELLO_SECRET',
            ]));
  });
  group('argument errors', () {
    //given
    var arguments = 'go forth and break things'.split(' ');

    var printer = FakePrinter();
    var envArgsEnvironment = EnvArgsEnvironment(
        platformEnvironment: validEnvironment,
        arguments: arguments,
        clientFactory: (_) => TestTrelloClient(responses: []).trelloClient,
        printer: printer.printer);
    //when
    setUpAll(() async => await app().run(envArgsEnvironment));
    //then
    test(
        'output',
        () => expect(printer.output, [
              'Could not find a command named "go".',
              '',
              'Usage: trello <command> [arguments]',
              '',
              'Global options:',
              '-h, --help    Print this usage information.',
              '',
              'Available commands:',
              '  board    Trello Boards',
              '  card     Trello Cards',
              '  list     Trello Lists',
              '  member   Trello Members (users)',
              '',
              'Run "trello help <command>" for more information about a command.'
            ]));
  });
}
