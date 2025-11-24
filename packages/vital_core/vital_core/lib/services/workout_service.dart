library vital;

import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:vital_core/services/data/workout.dart';
import 'package:vital_core/services/utils/http_logging_interceptor.dart';
import 'package:vital_core/services/utils/json_serializable_converter.dart';
import 'package:http/http.dart' as http;

part 'workout_service.chopper.dart';

@ChopperApi()
abstract class WorkoutService extends ChopperService {
  @GET(path: 'summary/workouts/{user_id}')
  Future<Response<WorkoutsResponse>> getWorkouts(
    @Path('user_id') String userId,
    @Query('start_date') DateTime startDate, {
    @Query('end_date') DateTime? endDate,
    @Query('provider') String? provider,
  });

  @GET(path: 'summary/workouts/{user_id}/raw')
  Future<Response<Object>> getWorkoutsRaw(
    @Path('user_id') String userId,
    @Query('start_date') DateTime startDate,
    @Query('end_date') DateTime? endDate,
    @Query('provider') String? provider,
  );

  @GET(path: 'timeseries/workouts/{workout_id}/stream')
  Future<Response<WorkoutStreamResponse>> getWorkoutStream(
    @Path('workout_id') String workoutId,
  );

  static WorkoutService create(
      http.Client httpClient, Uri baseUrl, Interceptor authInterceptor) {
    final client = ChopperClient(
        client: httpClient,
        baseUrl: baseUrl,
        interceptors: [
          HttpRequestLoggingInterceptor(),
          authInterceptor,
        ],
        converter: const JsonSerializableConverter({
          WorkoutsResponse: WorkoutsResponse.fromJson,
          WorkoutStreamResponse: WorkoutStreamResponse.fromJson,
        }));

    return _$WorkoutService(client);
  }
}
