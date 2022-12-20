library vital;

import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;
import 'package:vital_core/services/utils/http_api_key_interceptor.dart';
import 'package:vital_core/services/utils/http_logging_interceptor.dart';
import 'package:vital_core/services/utils/json_serializable_converter.dart';

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

  @Get(path: 'timeseries/{user_id}/{resource}')
  Future<Response<List<BloodPressureMeasurement>>>
      _bloodPressureTimeseriesRequest(
    @Path('user_id') String userId,
    @Path('resource') String resource,
    @Query('start_date') String startDate, {
    @Query('end_date') String? endDate,
    @Query('provider') String? provider,
  });

  Future<Response<List<Measurement>>> getBloodOxygen(
    String userId,
    DateTime startDate, {
    DateTime? endDate,
    String? provider,
  }) {
    return _timeseriesRequest(userId, _ResourceType.bloodOxygen.toRequestQuery,
        startDate.toIso8601String(),
        endDate: endDate?.toIso8601String(), provider: provider);
  }

  Future<Response<List<BloodPressureMeasurement>>> getBloodPressure(
    String userId,
    DateTime startDate, {
    DateTime? endDate,
    String? provider,
  }) {
    return _bloodPressureTimeseriesRequest(userId,
        _ResourceType.bloodPressure.toRequestQuery, startDate.toIso8601String(),
        endDate: endDate?.toIso8601String(), provider: provider);
  }

  Future<Response<List<Measurement>>> getGlucose(
    String userId,
    DateTime startDate, {
    DateTime? endDate,
    String? provider,
  }) {
    return _timeseriesRequest(userId, _ResourceType.glucose.toRequestQuery,
        startDate.toIso8601String(),
        endDate: endDate?.toIso8601String(), provider: provider);
  }

  Future<Response<List<Measurement>>> getHeartrate(
    String userId,
    DateTime startDate, {
    DateTime? endDate,
    String? provider,
  }) {
    return _timeseriesRequest(
      userId,
      _ResourceType.heartrate.toRequestQuery,
      startDate.toIso8601String(),
      endDate: endDate?.toIso8601String(),
      provider: provider,
    );
  }

  Future<Response<List<Measurement>>> getHeartrateVariability(
    String userId,
    DateTime startDate, {
    DateTime? endDate,
    String? provider,
  }) {
    return _timeseriesRequest(
      userId,
      _ResourceType.heartrateVariability.toRequestQuery,
      startDate.toIso8601String(),
      endDate: endDate?.toIso8601String(),
      provider: provider,
    );
  }

  Future<Response<List<Measurement>>> getHypnogram(
    String userId,
    DateTime startDate, {
    DateTime? endDate,
    String? provider,
  }) {
    return _timeseriesRequest(
      userId,
      _ResourceType.hypnogram.toRequestQuery,
      startDate.toIso8601String(),
      endDate: endDate?.toIso8601String(),
      provider: provider,
    );
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
      '${_ResourceType.cholesterol.toRequestQuery}/${cholesterolType.name}',
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
      _ResourceType.ige.toRequestQuery,
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
      _ResourceType.igg.toRequestQuery,
      startDate.toIso8601String(),
      endDate: endDate?.toIso8601String(),
      provider: provider,
    );
  }

  Future<Response<List<Measurement>>> getRespiratoryRate(
    String userId,
    DateTime startDate, {
    DateTime? endDate,
    String? provider,
  }) {
    return _timeseriesRequest(
      userId,
      _ResourceType.respiratoryRate.toRequestQuery,
      startDate.toIso8601String(),
      endDate: endDate?.toIso8601String(),
      provider: provider,
    );
  }

  Future<Response<List<Measurement>>> getSteps(
    String userId,
    DateTime startDate, {
    DateTime? endDate,
    String? provider,
  }) {
    return _timeseriesRequest(
      userId,
      _ResourceType.steps.toRequestQuery,
      startDate.toIso8601String(),
      endDate: endDate?.toIso8601String(),
      provider: provider,
    );
  }

  static VitalsService create(
      http.Client httpClient, String baseUrl, String apiKey) {
    final client = ChopperClient(
        client: httpClient,
        baseUrl: baseUrl,
        interceptors: [
          HttpRequestLoggingInterceptor(),
          HttpApiKeyInterceptor(apiKey)
        ],
        converter: const JsonSerializableConverter({
          Measurement: Measurement.fromJson,
          BloodPressureMeasurement: BloodPressureMeasurement.fromJson,
        }));

    return _$VitalsService(client);
  }
}

enum _ResourceType {
  bloodOxygen,
  bloodPressure,
  cholesterol,
  glucose,
  heartrate,
  heartrateVariability,
  hypnogram,
  igg,
  ige,
  respiratoryRate,
  steps
}

extension _ResourceTypeExt on _ResourceType {
  String get toRequestQuery {
    switch (this) {
      case _ResourceType.bloodOxygen:
        return 'blood_oxygen';
      case _ResourceType.bloodPressure:
        return 'blood_pressure';
      case _ResourceType.cholesterol:
        return 'cholesterol';
      case _ResourceType.glucose:
        return 'glucose';
      case _ResourceType.heartrate:
        return 'heartrate';
      case _ResourceType.heartrateVariability:
        return 'hrv';
      case _ResourceType.hypnogram:
        return 'hypnogram';
      case _ResourceType.igg:
        return 'igg';
      case _ResourceType.ige:
        return 'ige';
      case _ResourceType.respiratoryRate:
        return 'respiratory_rate';
      case _ResourceType.steps:
        return 'steps';
    }
  }
}
