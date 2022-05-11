import 'dart:io';

import 'package:trello_sdk/src/sdk/external/dio_client_factory.dart';
import 'package:trello_sdk/trello_cli.dart';

Future<void> main(List<String> arguments) async {
  await app().run(EnvArgsEnvironment(
      platformEnvironment: Platform.environment,
      arguments: arguments,
      clientFactory: dioClientFactory,
      printer: (s) => print(s)));
}
