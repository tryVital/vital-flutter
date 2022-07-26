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
  Future<Response<WorkoutsResponse>> getWorkouts(
      String userId, DateTime startDate,
      {DateTime? endDate, String? provider}) {
    final $url = 'summary/workouts/${userId}';
    final $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'provider': provider
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<WorkoutsResponse, WorkoutsResponse>($request);
  }

  @override
  Future<Response<Object>> getWorkoutsRaw(
      String userId, DateTime startDate, DateTime? endDate, String? provider) {
    final $url = 'summary/workouts/${userId}/raw';
    final $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'provider': provider
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<WorkoutStreamResponse>> getWorkoutStream(String workoutId) {
    final $url = 'timeseries/workouts/${workoutId}/stream';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<WorkoutStreamResponse, WorkoutStreamResponse>($request);
  }
}
