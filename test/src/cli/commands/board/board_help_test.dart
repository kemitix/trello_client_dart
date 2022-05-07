import 'package:test/test.dart';
import 'package:trello_sdk/trello_cli.dart';

import '../../../mocks/dio_mock.dart';
import '../../cli_commons.dart';

void main() {
  group('help output', () {
    //given
    var arguments = 'board --help'.split(' ');

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
              'Trello Boards',
              '',
              'Usage: trello board <subcommand> [arguments]',
              '-h, --help    Print this usage information.',
              '',
              'Available subcommands:',
              '  list-lists   Get Lists on a Board',
              '',
              'Run "trello help" to see global options.'
            ]));
  });
}
