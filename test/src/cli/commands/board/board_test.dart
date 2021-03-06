import '../../cli_commons.dart' show CliExpectations, cliTest;

void main() => cliTest(
      arguments: 'board'.split(' '),
      responses: [],
      testNotFound: false,
      testServerError: false,
      expectations: CliExpectations(
        requests: [],
        output: [
          'Missing subcommand for "trello board".',
          '',
          'Usage: trello board <subcommand> [arguments]',
          '-h, --help    Print this usage information.',
          '',
          'Available subcommands:',
          '  list-lists   Get Lists on a Board',
          '',
          'Run "trello help" to see global options.'
        ],
        help: [
          'Trello Boards',
          '',
          'Usage: trello board <subcommand> [arguments]',
          '-h, --help    Print this usage information.',
          '',
          'Available subcommands:',
          '  list-lists   Get Lists on a Board',
          '',
          'Run "trello help" to see global options.'
        ],
      ),
    );
