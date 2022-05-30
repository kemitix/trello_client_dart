import 'package:test/test.dart' show expect, group, setUpAll, test;
import 'package:trello_sdk/trello_cli.dart' show EnvArgsEnvironment, app;

import '../mocks/dio_mock.dart' show TestTrelloClient;
import 'cli_commons.dart' show FakePrinter, validEnvironment;

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
  group('help output', () {
    //given
    var arguments = '--help'.split(' ');

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
              'A CLI for Trello',
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
