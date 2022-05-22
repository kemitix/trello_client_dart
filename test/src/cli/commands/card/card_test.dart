import '../../cli_commons.dart';

void main() => cliTest(
      arguments: 'card'.split(' '),
      responses: [],
      expected: CliExpectations(
        requests: [],
        output: [
          'Missing subcommand for "trello card".',
          '',
          'Usage: trello card <subcommand> [arguments]',
          '-h, --help    Print this usage information.',
          '',
          'Available subcommands:',
          '  add-member            Add a Member to a Card',
          '  download-attachment   Download an Attachment file',
          '  get                   Get a Card',
          '  get-attachment        Get an Attachment on a Card',
          '  list-attachments      List Attachments on a Card',
          '  remove-member         Remove a Member from a Card',
          '  update                Update a Card',
          '',
          'Run "trello help" to see global options.'
        ],
        help: [
          'Trello Cards',
          '',
          'Usage: trello card <subcommand> [arguments]',
          '-h, --help    Print this usage information.',
          '',
          'Available subcommands:',
          '  add-member            Add a Member to a Card',
          '  download-attachment   Download an Attachment file',
          '  get                   Get a Card',
          '  get-attachment        Get an Attachment on a Card',
          '  list-attachments      List Attachments on a Card',
          '  remove-member         Remove a Member from a Card',
          '  update                Update a Card',
          '',
          'Run "trello help" to see global options.'
        ],
      ),
    );
