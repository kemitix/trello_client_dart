import 'package:args/command_runner.dart' show UsageException;
import 'package:trello_client/trello_sdk.dart'
    show Reader, TrelloAuthentication, TrelloClient;

import 'authentication.dart' show authentication;
import 'commands/commands.dart' show CommandEnvironment;
import 'runner.dart' show Environment, runner;

class EnvArgsEnvironment {
  EnvArgsEnvironment({
    required Environment platformEnvironment,
    required List<String> arguments,
    required TrelloClient Function(TrelloAuthentication) clientFactory,
    required void Function(Object) printer,
  }) {
    _env = platformEnvironment;
    _args = arguments;
    _clientFactory = clientFactory;
    _printer = printer;
  }

  late final Environment _env;
  late final List<String> _args;
  late final TrelloClient Function(TrelloAuthentication) _clientFactory;
  late final void Function(Object object) _printer;

  Environment get env => _env;

  List<String> get args => _args;

  TrelloClient Function(TrelloAuthentication) get clientFactory =>
      _clientFactory;

  void Function(Object object) get printer => _printer;
}

class ArgsClientEnvironment {
  ArgsClientEnvironment({
    required List<String> arguments,
    required TrelloClient client,
    required void Function(Object) printer,
  }) {
    _args = arguments;
    _client = client;
    _printer = printer;
  }

  late final List<String> _args;
  late final TrelloClient _client;
  late final void Function(Object object) _printer;

  List<String> get args => _args;

  TrelloClient get client => _client;

  void Function(Object object) get printer => _printer;
}

Reader<EnvArgsEnvironment, Future<void>> app() =>
    Reader((envArgsEnv) => authentication(envArgsEnv.env)
        .map((auth) => envArgsEnv.clientFactory(auth))
        .map((client) => ArgsClientEnvironment(
            arguments: envArgsEnv.args,
            client: client,
            printer: envArgsEnv.printer))
        .fold(
          (errors) async => errors.forEach(_handleError(envArgsEnv)),
          (argsClientEnv) => runApp().run(argsClientEnv),
        ));

void Function(dynamic) _handleError(EnvArgsEnvironment envArgsEnvironment) =>
    (dynamic error) => envArgsEnvironment.printer(error);

Reader<ArgsClientEnvironment, Future<void>> runApp() =>
    Reader((argsClientEnv) =>
        runner(CommandEnvironment(argsClientEnv.client, argsClientEnv.printer))
            .run(argsClientEnv.args)
            .catchError((error) {
          if (error is! UsageException) throw error;
          argsClientEnv.printer(error);
        }).whenComplete(() => argsClientEnv.client.close()));
