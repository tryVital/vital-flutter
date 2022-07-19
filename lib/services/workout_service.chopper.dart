// GENERATED CODE - DO NOT MODIFY BY HAND

part of vital;

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$WorkoutService extends WorkoutService {
  _$WorkoutService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = WorkoutService;

  @override
  Future<Response<Object>> getWorkout(
      String userId, DateTime startDate, DateTime? endDate, String? provider) {
    final $url = 'summary/workouts/${userId}';
    final $body = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'provider': provider
    };
    final $request = Request('GET', $url, client.baseUrl, body: $body);
    return client.send<Object, Object>($request,
        requestConverter: JsonConverter.requestFactory);
  }

  @override
  Future<Response<Object>> getWorkoutRaw(
      String userId, DateTime startDate, DateTime? endDate, String? provider) {
    final $url = 'summary/workouts/${userId}/raw';
    final $body = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'provider': provider
    };
    final $request = Request('GET', $url, client.baseUrl, body: $body);
    return client.send<Object, Object>($request,
        requestConverter: JsonConverter.requestFactory);
  }

  @override
  Future<Response<Object>> getWorkoutStream(String workoutId) {
    final $url = 'timeseries/workouts/${workoutId}/stream';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<Object, Object>($request,
        requestConverter: JsonConverter.requestFactory);
  }
}
