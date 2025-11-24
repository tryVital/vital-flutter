library vital;

import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:vital_core/services/data/sleep.dart';
import 'package:vital_core/services/utils/http_logging_interceptor.dart';
import 'package:vital_core/services/utils/json_serializable_converter.dart';
import 'package:http/http.dart' as http;

part 'sleep_service.chopper.dart';

@ChopperApi()
abstract class SleepService extends ChopperService {
  @GET(path: 'summary/sleep/{user_id}')
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
    return _getSleepData(userId, startDate.toIso8601String(),
        endDate?.toIso8601String(), provider);
  }

  @GET(path: 'summary/sleep/{user_id}/raw')
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
    return _getSleepDataRaw(userId, startDate.toIso8601String(),
        endDate?.toIso8601String(), provider);
  }

  static SleepService create(
      http.Client httpClient, Uri baseUrl, Interceptor authInterceptor) {
    final client = ChopperClient(
      client: httpClient,
      baseUrl: baseUrl,
      interceptors: [
        HttpRequestLoggingInterceptor(),
        authInterceptor,
      ],
      converter: const JsonSerializableConverter({
        SleepResponse: SleepResponse.fromJson,
      }),
    );

    return _$SleepService(client);
  }
}
