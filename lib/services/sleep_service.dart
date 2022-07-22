library vital;

import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:vital_flutter/services/data/sleep.dart';
import 'package:vital_flutter/services/utils/http_api_key_interceptor.dart';
import 'package:vital_flutter/services/utils/http_logging_interceptor.dart';
import 'package:vital_flutter/services/utils/json_serializable_converter.dart';
import 'package:http/http.dart' as http;

part 'sleep_service.chopper.dart';

@ChopperApi()
abstract class SleepService extends ChopperService {
  @Get(path: 'summary/sleep/{user_id}')
  Future<Response<SleepResponse>> _getSleepData(
    @Path('user_id') String userId,
    @Query('start_date') String startDate,
    @Query('end_date') String? endDate,
    @Query('provider') String? provider,
  );

  Future<Response<SleepResponse>> getSleepData(
    String userId,
    DateTime startDate,
    DateTime? endDate,
    String? provider,
  ) {
    return _getSleepData(userId, startDate.toIso8601String(), endDate?.toIso8601String(), provider);
  }

  @Get(path: 'summary/sleep/{user_id}/stream')
  Future<Response<SleepResponse>> _getSleepStreamSeries(
    @Path('user_id') String userId,
    @Query('start_date') String startDate,
    @Query('end_date') String? endDate,
    @Query('provider') String? provider,
  );

  Future<Response<SleepResponse>> getSleepStreamSeries(
    @Path('user_id') String userId,
    @Query('start_date') DateTime startDate,
    @Query('end_date') DateTime? endDate,
    @Query('provider') String? provider,
  ) {
    return _getSleepStreamSeries(userId, startDate.toIso8601String(), endDate?.toIso8601String(), provider);
  }

  @Get(path: 'summary/sleep/{user_id}/raw')
  Future<Response<Object>> _getSleepDataRaw(
    @Path('user_id') String userId,
    @Query('start_date') String startDate,
    @Query('end_date') String? endDate,
    @Query('provider') String? provider,
  );

  Future<Response<Object>> getSleepDataRaw(
    @Path('user_id') String userId,
    @Query('start_date') DateTime startDate,
    @Query('end_date') DateTime? endDate,
    @Query('provider') String? provider,
  ) {
    return _getSleepDataRaw(userId, startDate.toIso8601String(), endDate?.toIso8601String(), provider);
  }

  @Get(path: 'timeseries/sleep/{sleep_id}/stream')
  Future<Response<SleepStreamResponse>> getSleepStream(@Path('sleep_id') String sleepId);

  static SleepService create(http.Client httpClient, String baseUrl, String apiKey) {
    final client = ChopperClient(
      client: httpClient,
      baseUrl: baseUrl,
      interceptors: [HttpRequestLoggingInterceptor(), HttpApiKeyInterceptor(apiKey)],
      converter: const JsonSerializableConverter({
        SleepResponse: SleepResponse.fromJson,
        SleepStreamResponse: SleepStreamResponse.fromJson,
      }),
    );

    return _$SleepService(client);
  }
}
