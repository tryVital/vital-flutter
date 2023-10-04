library vital;

import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:vital_core/services/data/workout.dart';
import 'package:vital_core/services/utils/http_api_key_interceptor.dart';
import 'package:vital_core/services/utils/http_logging_interceptor.dart';
import 'package:vital_core/services/utils/json_serializable_converter.dart';
import 'package:http/http.dart' as http;

part 'workout_service.chopper.dart';

@ChopperApi()
abstract class WorkoutService extends ChopperService {
  @Get(path: 'summary/workouts/{user_id}')
  Future<Response<WorkoutsResponse>> getWorkouts(
    @Path('user_id') String userId,
    @Query('start_date') DateTime startDate, {
    @Query('end_date') DateTime? endDate,
    @Query('provider') String? provider,
  });

  @Get(path: 'summary/workouts/{user_id}/raw')
  Future<Response<Object>> getWorkoutsRaw(
    @Path('user_id') String userId,
    @Query('start_date') DateTime startDate,
    @Query('end_date') DateTime? endDate,
    @Query('provider') String? provider,
  );

  @Get(path: 'timeseries/workouts/{workout_id}/stream')
  Future<Response<WorkoutStreamResponse>> getWorkoutStream(
    @Path('workout_id') String workoutId,
  );

  static WorkoutService create(
      http.Client httpClient, String baseUrl, String apiKey) {
    final client = ChopperClient(
        client: httpClient,
        baseUrl: baseUrl,
        interceptors: [
          HttpRequestLoggingInterceptor(),
          HttpApiKeyInterceptor(apiKey)
        ],
        converter: const JsonSerializableConverter({
          WorkoutsResponse: WorkoutsResponse.fromJson,
          WorkoutStreamResponse: WorkoutStreamResponse.fromJson,
        }));

    return _$WorkoutService(client);
  }
}
