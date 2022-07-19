library vital;

import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:vital_flutter/services/utils/http_api_key_interceptor.dart';
import 'package:vital_flutter/services/utils/http_logging_interceptor.dart';

part 'workout_service.chopper.dart';

@ChopperApi()
abstract class WorkoutService extends ChopperService {
  @Get(path: 'summary/workouts/{user_id}')
  @FactoryConverter(request: JsonConverter.requestFactory)
  Future<Response<Object>> getWorkout(
    @Path('user_id') String userId,
    @Field('start_date') DateTime startDate,
    @Field('end_date') DateTime? endDate,
    @Field('provider') String? provider,
  );

  @Get(path: 'summary/workouts/{user_id}/raw')
  @FactoryConverter(request: JsonConverter.requestFactory)
  Future<Response<Object>> getWorkoutRaw(
    @Path('user_id') String userId,
    @Field('start_date') DateTime startDate,
    @Field('end_date') DateTime? endDate,
    @Field('provider') String? provider,
  );

  @Get(path: 'timeseries/workouts/{workout_id}/stream')
  @FactoryConverter(request: JsonConverter.requestFactory)
  Future<Response<Object>> getWorkoutStream(
    @Path('workout_id') String workoutId,
  );

  static WorkoutService create(String baseUrl, String apiKey) {
    final client = ChopperClient(
      baseUrl: baseUrl,
      interceptors: [HttpRequestLoggingInterceptor(), HttpApiKeyInterceptor(apiKey)],
    );

    return _$WorkoutService(client);
  }
}
