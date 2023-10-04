// GENERATED CODE - DO NOT MODIFY BY HAND

part of vital;

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$VitalsService extends VitalsService {
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
    final $url = 'timeseries/${userId}/${resource}';
    final $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'provider': provider,
    };
    final $request = Request(
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
    final $url = 'timeseries/${userId}/${resource}';
    final $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'provider': provider,
    };
    final $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<BloodPressureMeasurement>,
        BloodPressureMeasurement>($request);
  }
}
