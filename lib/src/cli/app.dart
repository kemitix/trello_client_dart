import 'package:args/command_runner.dart';

import '../../trello_cli.dart';

class EnvArgsEnvironment {
  EnvArgsEnvironment(this._env, this._args, this._clientFactory);

  final Environment _env;
  final List<String> _args;
  final TrelloClient Function(TrelloAuthentication) _clientFactory;

  Environment get env => _env;
  List<String> get args => _args;
  TrelloClient Function(TrelloAuthentication) get clientFactory =>
      _clientFactory;
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
        .map((auth) => envArgsEnv.clientFactory(auth))
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
