import 'package:dio/dio.dart';

import '../../../trello_sdk.dart';
import '../src/sdk/http_client.dart';

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
