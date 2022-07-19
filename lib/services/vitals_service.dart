library vital;

import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:vital_flutter/services/utils/http_api_key_interceptor.dart';
import 'package:vital_flutter/services/utils/http_logging_interceptor.dart';

part 'vitals_service.chopper.dart';

@ChopperApi()
abstract class VitalsService extends ChopperService {
  @Get(path: 'timeseries/{user_id}/{resource}')
  @FactoryConverter(request: JsonConverter.requestFactory)
  Future<Response<Object>> _timeseriesRequest(
    @Path('user_id') String userId,
    @Path('resource') String resource,
    @Field('start_date') String startDate, {
    @Field('end_date') String? endDate,
    @Field('provider') String? provider,
  });

  Future<Response<Object>> getGlucose(
    String userId,
    String resource,
    String startDate, {
    String? endDate,
    String? provider,
  }) {
    return _timeseriesRequest(userId, 'glucose', startDate, endDate: endDate, provider: provider);
  }

  Future<Response<Object>> getCholesterol(
    String cholesterolType,
    String userId,
    String resource,
    String startDate, {
    String? endDate,
    String? provider,
  }) {
    return _timeseriesRequest(userId, 'cholesterol/$cholesterolType', startDate, endDate: endDate, provider: provider);
  }

  Future<Response<Object>> getIge(
    String userId,
    String resource,
    String startDate, {
    String? endDate,
    String? provider,
  }) {
    return _timeseriesRequest(userId, 'ige', startDate, endDate: endDate, provider: provider);
  }

  Future<Response<Object>> getIgg(
    String userId,
    String resource,
    String startDate, {
    String? endDate,
    String? provider,
  }) {
    return _timeseriesRequest(userId, 'igg', startDate, endDate: endDate, provider: provider);
  }

  Future<Response<Object>> getHeartrate(
    String userId,
    String resource,
    String startDate, {
    String? endDate,
    String? provider,
  }) {
    return _timeseriesRequest(userId, 'heartrate', startDate, endDate: endDate, provider: provider);
  }

  static VitalsService create(String baseUrl, String apiKey) {
    final client = ChopperClient(
      baseUrl: baseUrl,
      interceptors: [HttpRequestLoggingInterceptor(), HttpApiKeyInterceptor(apiKey)],
    );

    return _$VitalsService(client);
  }
}
