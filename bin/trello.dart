import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dio/dio.dart';
import 'package:trello_sdk/src/sdk/http_client.dart';
import 'package:trello_sdk/trello_cli.dart';

class MyInputs {
  final List<String> _args;
  final Environment _env;
  MyInputs(this._env, this._args);
  Environment get env => _env;
  List<String> get args => _args;
}

Future<void> main(List<String> arguments) {
  final myInputs = MyInputs(Platform.environment, arguments);
  return authentication()
      .run(myInputs.env)
      .map(trelloClient)
      .fold<Future<void>>(
        (error) async => print(error),
        (client) => runApp(client, arguments),
      );
}

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
