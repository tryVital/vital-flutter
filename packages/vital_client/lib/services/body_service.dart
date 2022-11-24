library vital;

import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:vital_client/services/data/body.dart';
import 'package:vital_client/services/utils/http_api_key_interceptor.dart';
import 'package:vital_client/services/utils/http_logging_interceptor.dart';
import 'package:vital_client/services/utils/json_serializable_converter.dart';
import 'package:http/http.dart' as http;

part 'body_service.chopper.dart';

@ChopperApi()
abstract class BodyService extends ChopperService {
  @Get(path: '/summary/body/{user_id}')
  Future<Response<BodyDataResponse>> getBodyData(
    @Path('user_id') String userId,
    @Query('start_date') DateTime startDate,
    @Query('end_date') DateTime? endDate,
    @Query('provider') String? provider,
  );

  static BodyService create(http.Client httpClient, String baseUrl, String apiKey) {
    final client = ChopperClient(
      client: httpClient,
      baseUrl: baseUrl,
      interceptors: [HttpRequestLoggingInterceptor(), HttpApiKeyInterceptor(apiKey)],
      converter: const JsonSerializableConverter({
        BodyDataResponse: BodyDataResponse.fromJson,
      }),
    );

    return _$BodyService(client);
  }
}
