library vital;

import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:vital_core/services/utils/http_api_key_interceptor.dart';
import 'package:vital_core/services/utils/http_logging_interceptor.dart';
import 'package:vital_core/services/utils/json_serializable_converter.dart';
import 'package:http/http.dart' as http;

import 'data/vitals.dart';

part 'vitals_service.chopper.dart';

@ChopperApi()
abstract class VitalsService extends ChopperService {
  @Get(path: 'timeseries/{user_id}/{resource}')
  Future<Response<List<Measurement>>> _timeseriesRequest(
    @Path('user_id') String userId,
    @Path('resource') String resource,
    @Query('start_date') String startDate, {
    @Query('end_date') String? endDate,
    @Query('provider') String? provider,
  });

  Future<Response<List<Measurement>>> getGlucose(
    String userId,
    DateTime startDate, {
    DateTime? endDate,
    String? provider,
  }) {
    return _timeseriesRequest(userId, 'glucose', startDate.toIso8601String(),
        endDate: endDate?.toIso8601String(), provider: provider);
  }

  Future<Response<List<Measurement>>> getCholesterol(
    CholesterolType cholesterolType,
    String userId,
    DateTime startDate, {
    DateTime? endDate,
    String? provider,
  }) {
    return _timeseriesRequest(
      userId,
      'cholesterol/${cholesterolType.name}',
      startDate.toIso8601String(),
      endDate: endDate?.toIso8601String(),
      provider: provider,
    );
  }

  Future<Response<List<Measurement>>> getIge(
    String userId,
    DateTime startDate, {
    DateTime? endDate,
    String? provider,
  }) {
    return _timeseriesRequest(
      userId,
      'ige',
      startDate.toIso8601String(),
      endDate: endDate?.toIso8601String(),
      provider: provider,
    );
  }

  Future<Response<List<Measurement>>> getIgg(
    String userId,
    DateTime startDate, {
    DateTime? endDate,
    String? provider,
  }) {
    return _timeseriesRequest(
      userId,
      'igg',
      startDate.toIso8601String(),
      endDate: endDate?.toIso8601String(),
      provider: provider,
    );
  }

  Future<Response<List<Measurement>>> getHeartrate(
    String userId,
    DateTime startDate, {
    DateTime? endDate,
    String? provider,
  }) {
    return _timeseriesRequest(
      userId,
      'heartrate',
      startDate.toIso8601String(),
      endDate: endDate?.toIso8601String(),
      provider: provider,
    );
  }

  static VitalsService create(http.Client httpClient, String baseUrl, String apiKey) {
    final client = ChopperClient(
        client: httpClient,
        baseUrl: baseUrl,
        interceptors: [HttpRequestLoggingInterceptor(), HttpApiKeyInterceptor(apiKey)],
        converter: const JsonSerializableConverter({
          Measurement: Measurement.fromJson,
        }));

    return _$VitalsService(client);
  }
}
