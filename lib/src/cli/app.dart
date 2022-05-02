import 'package:args/command_runner.dart';
import 'package:dio/dio.dart';

import '../../trello_cli.dart';
import '../sdk/http_client.dart';

class AppEnvironment {
  AppEnvironment(this._env, this._args);

  final List<String> _args;
  final Environment _env;

  Environment get env => _env;
  List<String> get args => _args;
}

Reader<AppEnvironment, Future<void>> app() =>
    Reader((e) => authentication(e.env).map(trelloClient).fold(
          (errors) async => errors.forEach(print),
          (client) => runApp(client, e.args),
        ));

Future<void> runApp(TrelloClient client, List<String> arguments) =>
    runner(client)
        .run(arguments)
        .catchError(_handleError)
        .whenComplete(() => client.close());

void _handleError(error) {
  if (error is! UsageException) throw error;
  print(error);
}

TrelloClient trelloClient(TrelloAuthentication authentication) => TrelloClient(
    DioHttpClient(
      baseUrl: 'https://api.trello.com',
      queryParameters: {
        'key': authentication.key,
        'token': authentication.token,
      },
      dioFactory: (String baseUrl, Map<String, String> queryParameters) =>
          Dio(BaseOptions(
        baseUrl: baseUrl,
        queryParameters: queryParameters,
      )),
    ),
    authentication);
