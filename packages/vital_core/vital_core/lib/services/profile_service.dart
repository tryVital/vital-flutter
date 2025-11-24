library vital;

import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:vital_core/services/data/profile.dart';
import 'package:vital_core/services/utils/http_logging_interceptor.dart';
import 'package:vital_core/services/utils/json_serializable_converter.dart';
import 'package:http/http.dart' as http;

part 'profile_service.chopper.dart';

@ChopperApi()
abstract class ProfileService extends ChopperService {
  @GET(path: 'summary/profile/{user_id}')
  Future<Response<Profile>> getProfile(
      @Path('user_id') String userId, @Query('provider') String? provider);

  @GET(path: 'summary/profile/{user_id}/raw')
  Future<Response<Object>> getProfileRaw(
      @Path('user_id') String userId, @Query('provider') String? provider);

  static ProfileService create(
      http.Client httpClient, Uri baseUrl, Interceptor authInterceptor) {
    final client = ChopperClient(
      client: httpClient,
      baseUrl: baseUrl,
      interceptors: [
        HttpRequestLoggingInterceptor(),
        authInterceptor,
      ],
      converter: const JsonSerializableConverter({
        Profile: Profile.fromJson,
      }),
    );

    return _$ProfileService(client);
  }
}
