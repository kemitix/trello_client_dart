import 'package:test/test.dart';

import '../../../sdk/sdk_commons.dart';
import '../../cli_commons.dart';

void main() {
  var helpOutput = [
    'Update a Card',
    '',
    'Usage: trello card update [arguments]',
    '-h, --help                   Print this usage information.',
    '    --name                   The new name for the card',
    '    --desc                   The new description for the card',
    '    --member-ids             Comma-separated list of member IDs',
    '    --[no-]closed            Whether the card should be archived (closed: true)',
    '    --attachment-cover-id    The ID of the image attachment the card should use as its cover, or blank for none',
    '    --list-id                The ID of the list the card should be in',
    '    --label-ids              Comma-separated list of label IDs',
    '    --board-id               The ID of the board the card should be on',
    '    --pos                    The position of the card in its list. top, bottom, or a positive float',
    '    --due                    When the card is due, or blank',
    '    --[no-]due-complete      Whether the due date should be marked complete',
    '    --[no-]subscribed        Whether the member is should be subscribed to the card',
    '    --address                For use with/by the Map View',
    '    --location-name          For use with/by the Map View',
    '    --coordinates            For use with/by the Map View. Should be latitude,longitude',
    '    --cover                  Updates the card\'s cover:',
    '                             - color       : pink, yellow, lime, blue, black, orange, red, purple, sky, green (Makes the cover a solid color)',
    '                             - brightness  : dark, light (Determines whether the text on the cover should be dark or light)',
    '                             - url         : An unsplash URL: https://images.unsplash.com (Used if making an image the cover. Only Unsplash URLs work)',
    '                             - idAttachment: ID of an attachment on the card (Used if setting an attached image as the cover)',
    '                             - size        : normal, full (Determines whether to show the card name on the cover, or below it)',
    '',
    'Run "trello help" to see global options.'
  ];
  cliTest(
      arguments: 'card update my-card-id --name new-name'.split(' '),
      responses: [
        createResponse(body: {
          'id': 'my-card-id',
          'pos': 'my-pos',
          'name': 'my-card-name',
          'due': '2022-05-05T09:45',
          'idMembers': ['my-member-id'],
        }),
      ],
      expectations: CliExpectations(
        requests: [
          ExpectedRequest(
            expectedMethod: 'PUT',
            expectedPath: '/1/cards/my-card-id',
            expectedHeaders: {
              'content-type': 'application/json; charset=utf-8',
              'content-length': '19'
            },
            expectedQueryParameters: {},
          ),
        ],
        output: ['Updated'],
        help: helpOutput,
        notFoundOutput: [
          'ERROR: card update - Failure: Resource not found: /1/cards/my-card-id'
        ],
        serverErrorOutput: [
          'ERROR: card update - Failure: PUT /1/cards/my-card-id'
        ],
      ));
  group(
      'no updates',
      () => cliTest(
          arguments: 'card update my-card-id'.split(' '),
          responses: [],
          testNotFound: false,
          testServerError: false,
          expectations: CliExpectations(
              requests: [],
              output: ['ERROR: card update - Failure: No updates'],
              help: helpOutput)));
  group(
      'no card-id',
      () => cliTest(
          arguments: 'card update'.split(' '),
          responses: [],
          testNotFound: false,
          testServerError: false,
          expectations: CliExpectations(
              requests: [],
              output: ['ERROR: card update - Failure: Card Id not given'],
              help: helpOutput)));
}
