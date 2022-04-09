import 'package:trello_client/src/fp/fp.dart';
import 'package:trello_client/src/models/models.dart';
import 'package:trello_client/trello_client.dart';

typedef Error = String;
typedef ErrorList = List<Error>;

Future<void> main(List<String> arguments) async =>
    await parseArgs(arguments).map(trelloClient).fold<Future<void>>(
          onError: (errors) => reportErrors(errors),
          onSuccess: (client) => runApp(client),
        );

Future<void> runApp(TrelloClient client) async {
  print('Select Board:');
  List<Board> boards = await client.members
      .getMemberBoards(fields: [BoardFields.id, BoardFields.name]);
  boards
      .asMap()
      .entries
      .map((entry) => "- ${entry.key + 1}: ${entry.value.name}")
      .forEach(print);
  client.close();
}

Future<void> reportErrors(ErrorList errors) async => errors.forEach(print);

Either<ErrorList, TrelloAuthentication> parseArgs(List<String> arguments) {
  if (arguments.isEmpty) {
    return Left.of(['Trello Username, API key and token not given']);
  }
  final String username = arguments[0];
  if (arguments.length < 2) {
    return Left.of(['Trello API key and token not given']);
  }
  final String key = arguments[1];
  if (arguments.length < 3) {
    return Left.of(['Trello API token not given']);
  }
  final String secret = arguments[2];
  if (arguments.length > 3) {
    return Left.of(['Too many arguments']);
  }
  return Right.of(TrelloAuthentication.of(username, key, secret));
}

TrelloClient trelloClient(TrelloAuthentication authentication) =>
    TrelloClient(authentication);
