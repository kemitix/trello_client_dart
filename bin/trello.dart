import 'dart:io' show Platform;

import 'package:trello_client/external/dio_client_factory.dart'
    show dioClientFactory;
import 'package:trello_client/trello_cli.dart' show EnvArgsEnvironment, app;

Future<void> main(List<String> arguments) async {
  await app().run(EnvArgsEnvironment(
      platformEnvironment: Platform.environment,
      arguments: arguments,
      clientFactory: dioClientFactory,
      printer: (s) => print(s)));
}
