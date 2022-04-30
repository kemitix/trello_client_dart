import 'dart:async';
import 'dart:io';

import 'package:trello_sdk/trello_cli.dart';

Future<void> main(List<String> arguments) => app().run(AppEnvironment(
      Platform.environment,
      arguments,
    ));
