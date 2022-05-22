import '../../cli_commons.dart';

void main() => cliTest(
      arguments: 'board'.split(' '),
      expectedRequests: [],
      responses: [],
      expectedOutput: [
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
      expectedHelp: [
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
      testNotFound: false,
      testServerError: false,
    );
