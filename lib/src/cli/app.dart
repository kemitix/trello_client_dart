import 'package:args/command_runner.dart';
import 'package:dio/dio.dart';

import '../../trello_cli.dart';
import '../sdk/http_client.dart';

class EnvArgsEnvironment {
  EnvArgsEnvironment(this._env, this._args);

  final Environment _env;
  final List<String> _args;

  Environment get env => _env;
  List<String> get args => _args;
}

class ArgsClientEnvironment {
  ArgsClientEnvironment(this._args, this._client);

  final List<String> _args;
  final TrelloClient _client;

  List<String> get args => _args;
  TrelloClient get client => _client;
}

Reader<EnvArgsEnvironment, Future<void>> app() =>
    Reader((envArgsEnv) => authentication(envArgsEnv.env)
        .map(trelloClient)
        .map((client) => ArgsClientEnvironment(envArgsEnv.args, client))
        .fold(
          (errors) async => errors.forEach(print),
          (argsClientEnv) => runApp().run(argsClientEnv),
        ));

Reader<ArgsClientEnvironment, Future<void>> runApp() =>
    Reader((argsClientEnv) => runner(argsClientEnv.client)
        .run(argsClientEnv.args)
        .catchError(_handleError)
        .whenComplete(() => argsClientEnv.client.close()));

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
