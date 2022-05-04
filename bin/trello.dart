import 'dart:io';

import 'package:trello_sdk/trello_cli.dart';

Future<void> main(List<String> arguments) async {
  await app().run(EnvArgsEnvironment(
      platformEnvironment: Platform.environment,
      arguments: arguments,
      clientFactory: trelloClient,
      printer: (s) => print(s)));
}
