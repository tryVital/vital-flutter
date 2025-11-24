// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'workout_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$WorkoutService extends WorkoutService {
  _$WorkoutService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = WorkoutService;

  @override
  Future<Response<WorkoutsResponse>> getWorkouts(
    String userId,
    DateTime startDate, {
    DateTime? endDate,
    String? provider,
  }) {
    final Uri $url = Uri.parse('summary/workouts/${userId}');
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
    return client.send<WorkoutsResponse, WorkoutsResponse>($request);
  }

  @override
  Future<Response<Object>> getWorkoutsRaw(
    String userId,
    DateTime startDate,
    DateTime? endDate,
    String? provider,
  ) {
    final Uri $url = Uri.parse('summary/workouts/${userId}/raw');
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
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<WorkoutStreamResponse>> getWorkoutStream(String workoutId) {
    final Uri $url = Uri.parse('timeseries/workouts/${workoutId}/stream');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<WorkoutStreamResponse, WorkoutStreamResponse>($request);
  }
}
