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
  @Get(path: 'user/')
  Future<Response<GetAllUsersResponse>> getAll();

  @Get(path: 'user/{user_id}')
  Future<Response<User>> getUser(@Path('user_id') String userId);

  @Post(path: '/user')
  @FactoryConverter(
    request: JsonConverter.requestFactory,
  )
  Future<Response<CreateUserResponse>> createUser(
      @Field('client_user_id') String clientUserId,
      {@Field('fallback_time_zone') String? fallbackTimeZone});

  @Patch(path: '/user/{user_id}')
  @FactoryConverter(
    request: JsonConverter.requestFactory,
  )
  Future<Response<NoContent>> patchUser(@Path('user_id') String userId,
      {@Field('fallback_time_zone') String? fallbackTimeZone});

  @Post(path: '/user/{user_id}/sign_in_token', optionalBody: true)
  @FactoryConverter(
    request: JsonConverter.requestFactory,
  )
  Future<Response<CreateSignInTokenResponse>> createSignInToken(
      @Path('user_id') String userId);

  @Delete(path: 'user/{user_id}')
  Future<Response<DeleteUserResponse>> deleteUser(
      @Path('user_id') String userId);

  @Get(path: '/user/key/{client_user_id}')
  Future<Response<User>> resolveUser(
      @Path('client_user_id') String clientUserId);

  @Get(path: '/user/providers/{user_id}')
  Future<Response<ProvidersResponse>> getProviders(
      @Path('user_id') String userId);

  @Delete(path: '/user/{user_id}/{provider}')
  Future<Response<DeregisterProviderResponse>> deregisterProvider(
    @Path('user_id') String userId,
    @Path('provider') String provider,
  );

  @Post(path: '/user/refresh/{user_id}', optionalBody: true)
  Future<Response<RefreshResponse>> refreshUser(@Path('user_id') String userId);

  static UserService create(
      http.Client httpClient, Uri baseUrl, RequestInterceptor authInterceptor) {
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
          ProvidersResponse: ProvidersResponse.fromJson,
          CreateUserResponse: CreateUserResponse.fromJson,
          DeleteUserResponse: DeleteUserResponse.fromJson,
          DeregisterProviderResponse: DeregisterProviderResponse.fromJson,
          GetAllUsersResponse: GetAllUsersResponse.fromJson,
          CreateSignInTokenResponse: CreateSignInTokenResponse.fromJson,
        }));

    return _$UserService(client);
  }
}
