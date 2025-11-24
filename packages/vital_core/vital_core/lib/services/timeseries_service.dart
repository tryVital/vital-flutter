library vital;

import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;
import 'package:vital_core/services/utils/http_logging_interceptor.dart';
import 'package:vital_core/services/utils/json_serializable_converter.dart';

import 'data/timeseries.dart';

part 'timeseries_service.chopper.dart';

@ChopperApi()
abstract class TimeseriesService extends ChopperService {
  @GET(path: 'timeseries/{user_id}/{resource}')
  Future<Response<GroupedIntervalTimeseriesResponse>>
      _intervalTimeseriesRequest(
    @Path('user_id') String userId,
    @Path('resource') String resource,
    @Query('start_date') String startDate, {
    @Query('end_date') String? endDate,
    @Query('provider') String? provider,
    @Query('next_cursor') String? nextCursor,
  });

  @GET(path: 'timeseries/{user_id}/{resource}')
  Future<Response<GroupedScalarTimeseriesResponse>> _scalarTimeseriesRequest(
    @Path('user_id') String userId,
    @Path('resource') String resource,
    @Query('start_date') String startDate, {
    @Query('end_date') String? endDate,
    @Query('provider') String? provider,
    @Query('next_cursor') String? nextCursor,
  });

  @GET(path: 'timeseries/{user_id}/blood_pressure')
  Future<Response<GroupedBloodPressureTimeseriesResponse>>
      _bloodPressureTimeseriesRequest(
    @Path('user_id') String userId,
    @Query('start_date') String startDate, {
    @Query('end_date') String? endDate,
    @Query('provider') String? provider,
    @Query('next_cursor') String? nextCursor,
  });

  Future<Response<GroupedScalarTimeseriesResponse>> scalarTimeseries(
    ScalarTimeseriesResource resource,
    String userId,
    DateTime startDate, {
    DateTime? endDate,
    String? provider,
    String? nextCursor,
  }) {
    return _scalarTimeseriesRequest(
      userId,
      resource.toJson(),
      startDate.toIso8601String(),
      endDate: endDate?.toIso8601String(),
      provider: provider,
      nextCursor: nextCursor,
    );
  }

  Future<Response<GroupedIntervalTimeseriesResponse>> intervalTimeseries(
    IntervalTimeseriesResource resource,
    String userId,
    DateTime startDate, {
    DateTime? endDate,
    String? provider,
    String? nextCursor,
  }) {
    return _intervalTimeseriesRequest(
      userId,
      resource.toJson(),
      startDate.toIso8601String(),
      endDate: endDate?.toIso8601String(),
      provider: provider,
      nextCursor: nextCursor,
    );
  }

  Future<Response<GroupedBloodPressureTimeseriesResponse>>
      bloodPressureTimeseries(
    String userId,
    DateTime startDate, {
    DateTime? endDate,
    String? provider,
    String? nextCursor,
  }) {
    return _bloodPressureTimeseriesRequest(
      userId,
      startDate.toIso8601String(),
      endDate: endDate?.toIso8601String(),
      provider: provider,
      nextCursor: nextCursor,
    );
  }

  static TimeseriesService create(
      http.Client httpClient, Uri baseUrl, Interceptor authInterceptor) {
    final client = ChopperClient(
        client: httpClient,
        baseUrl: baseUrl,
        interceptors: [
          HttpRequestLoggingInterceptor(),
          authInterceptor,
        ],
        converter: const JsonSerializableConverter({
          GroupedScalarTimeseriesResponse:
              GroupedScalarTimeseriesResponse.fromJson,
          GroupedIntervalTimeseriesResponse:
              GroupedIntervalTimeseriesResponse.fromJson,
          GroupedBloodPressureTimeseriesResponse:
              GroupedBloodPressureTimeseriesResponse.fromJson
        }));

    return _$TimeseriesService(client);
  }
}
