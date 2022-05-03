import 'package:args/command_runner.dart';

import '../../trello_cli.dart';

class EnvArgsEnvironment {
  EnvArgsEnvironment(this._env, this._args, this._clientFactory, this._printer);

  final Environment _env;
  final List<String> _args;
  final TrelloClient Function(TrelloAuthentication) _clientFactory;
  final void Function(Object object) _printer;

  Environment get env => _env;
  List<String> get args => _args;
  TrelloClient Function(TrelloAuthentication) get clientFactory =>
      _clientFactory;
  void Function(Object object) get printer => _printer;
}

class ArgsClientEnvironment {
  ArgsClientEnvironment(this._args, this._client, this._printer);

  final List<String> _args;
  final TrelloClient _client;
  final void Function(Object object) _printer;

  List<String> get args => _args;
  TrelloClient get client => _client;
  void Function(Object object) get printer => _printer;
}

Reader<EnvArgsEnvironment, Future<void>> app() =>
    Reader((envArgsEnv) => authentication(envArgsEnv.env)
        .map((auth) => envArgsEnv.clientFactory(auth))
        .map((client) => ArgsClientEnvironment(envArgsEnv.args, client, envArgsEnv.printer))
        .fold(
          (errors) async => errors.forEach(_handleError(envArgsEnv)),
          (argsClientEnv) => runApp().run(argsClientEnv),
        ));

void Function(dynamic) _handleError(EnvArgsEnvironment envArgsEnvironment) =>
        (dynamic error) => envArgsEnvironment.printer(error);

Reader<ArgsClientEnvironment, Future<void>> runApp() =>
    Reader((argsClientEnv) => runner(CommandEnvironment(argsClientEnv.client, argsClientEnv.printer))
        .run(argsClientEnv.args)
        .catchError((error) {
          if (error is! UsageException) throw error;
          argsClientEnv.printer(error);
        })
        .whenComplete(() => argsClientEnv.client.close()));
