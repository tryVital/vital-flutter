// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vitals_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: type=lint
final class _$VitalsService extends VitalsService {
  _$VitalsService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = VitalsService;

  @override
  Future<Response<List<Measurement>>> _timeseriesRequest(
    String userId,
    String resource,
    String startDate, {
    String? endDate,
    String? provider,
  }) {
    final Uri $url = Uri.parse('timeseries/${userId}/${resource}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'provider': provider,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<Measurement>, Measurement>($request);
  }

  @override
  Future<Response<List<BloodPressureMeasurement>>>
      _bloodPressureTimeseriesRequest(
    String userId,
    String resource,
    String startDate, {
    String? endDate,
    String? provider,
  }) {
    final Uri $url = Uri.parse('timeseries/${userId}/${resource}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'provider': provider,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<BloodPressureMeasurement>,
        BloodPressureMeasurement>($request);
  }
}
