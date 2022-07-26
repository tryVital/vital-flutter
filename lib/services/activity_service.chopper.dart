// GENERATED CODE - DO NOT MODIFY BY HAND

part of vital;

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$ActivityService extends ActivityService {
  _$ActivityService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ActivityService;

  @override
  Future<Response<ActivitiesResponse>> _getActivity(
      String userId, String startDate, String? endDate, String? provider) {
    final $url = 'summary/activity/${userId}';
    final $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'provider': provider
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<ActivitiesResponse, ActivitiesResponse>($request,
        requestConverter: JsonConverter.requestFactory);
  }

  @override
  Future<Response<Object>> getActivityRaw(
      String userId, DateTime startDate, DateTime? endDate, String? provider) {
    final $url = 'summary/activity/${userId}/raw';
    final $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'provider': provider
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<Object, Object>($request);
  }
}
