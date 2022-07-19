// GENERATED CODE - DO NOT MODIFY BY HAND

part of vital;

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$SleepService extends SleepService {
  _$SleepService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = SleepService;

  @override
  Future<Response<SleepResponse>> _getSleepData(
      String userId, String startDate, String? endDate, String? provider) {
    final $url = 'summary/sleep/${userId}';
    final $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'provider': provider
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<SleepResponse, SleepResponse>($request);
  }

  @override
  Future<Response<SleepResponse>> _getSleepStreamSeries(
      String userId, String startDate, String? endDate, String? provider) {
    final $url = 'summary/sleep/${userId}/stream';
    final $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'provider': provider
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<SleepResponse, SleepResponse>($request);
  }

  @override
  Future<Response<Object>> _getSleepDataRaw(
      String userId, String startDate, String? endDate, String? provider) {
    final $url = 'summary/sleep/${userId}/raw';
    final $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'provider': provider
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<SleepStreamResponse>> getSleepStream(String sleepId) {
    final $url = 'timeseries/sleep/${sleepId}/stream';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<SleepStreamResponse, SleepStreamResponse>($request);
  }
}
