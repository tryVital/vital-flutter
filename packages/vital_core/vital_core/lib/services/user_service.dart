library vital;

import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;
import 'package:vital_core/services/utils/http_logging_interceptor.dart';

import 'data/user.dart';
import 'utils/json_serializable_converter.dart';

part 'user_service.chopper.dart';

@ChopperApi()
abstract class UserService extends ChopperService {
  @GET(path: 'user/{user_id}')
  Future<Response<User>> getUser(@Path('user_id') String userId);

  @PATCH(path: '/user/{user_id}')
  @FactoryConverter(
    request: JsonConverter.requestFactory,
  )
  Future<Response<NoContent>> patchUser(@Path('user_id') String userId,
      {@Field('fallback_time_zone') String? fallbackTimeZone});

  @DELETE(path: '/user/{user_id}/{provider}')
  Future<Response<DeregisterProviderResponse>> deregisterProvider(
    @Path('user_id') String userId,
    @Path('provider') String provider,
  );

  @POST(path: '/user/refresh/{user_id}', optionalBody: true)
  Future<Response<RefreshResponse>> refreshUser(@Path('user_id') String userId);

  static UserService create(
      http.Client httpClient, Uri baseUrl, Interceptor authInterceptor) {
    final client = ChopperClient(
        client: httpClient,
        baseUrl: baseUrl,
        interceptors: [
          HttpRequestLoggingInterceptor(),
          authInterceptor,
        ],
        converter: const JsonSerializableConverter({
          User: User.fromJson,
          UserFallbackTimeZone: UserFallbackTimeZone.fromJson,
          RefreshResponse: RefreshResponse.fromJson,
          DeregisterProviderResponse: DeregisterProviderResponse.fromJson,
        }));

    return _$UserService(client);
  }
}
