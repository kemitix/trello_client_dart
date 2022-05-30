import 'package:dio/dio.dart' show BaseOptions, Dio;
import 'package:trello_sdk/trello_sdk.dart'
    show DioHttpClient, TrelloAuthentication, TrelloClient;

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
