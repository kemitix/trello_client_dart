import 'package:dio/dio.dart' show BaseOptions, Dio;
import 'package:trello_client/src/sdk/dio_http_client.dart';
import 'package:trello_client/trello_sdk.dart'
    show TrelloAuthentication, TrelloClient;

TrelloClient dioClientFactory(TrelloAuthentication authentication) =>
    TrelloClient(
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
