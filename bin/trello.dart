import 'dart:io';

import 'package:trello_sdk/trello_cli.dart';

Future<void> main(List<String> arguments) async {
  await app().run(AppEnvironment(
    Platform.environment,
    arguments,
  ));
}
