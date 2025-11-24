library vital;

import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;
import 'package:vital_core/services/data/user.dart';
import 'package:vital_core/services/utils/http_logging_interceptor.dart';

import 'data/control_plane.dart';
import 'utils/json_serializable_converter.dart';

part 'control_plane_service.chopper.dart';

@ChopperApi()
abstract class ControlPlaneService extends ChopperService {
  @GET(path: 'user/')
  Future<Response<GetAllUsersResponse>> getAll();

  @POST(path: '/user')
  @FactoryConverter(
    request: JsonConverter.requestFactory,
  )
  Future<Response<CreateUserResponse>> createUser(
      @Field('client_user_id') String clientUserId,
      {@Field('fallback_time_zone') String? fallbackTimeZone});

  @POST(path: '/user/{user_id}/sign_in_token', optionalBody: true)
  @FactoryConverter(
    request: JsonConverter.requestFactory,
  )
  Future<Response<CreateSignInTokenResponse>> createSignInToken(
      @Path('user_id') String userId);

  @DELETE(path: 'user/{user_id}')
  Future<Response<DeleteUserResponse>> deleteUser(
      @Path('user_id') String userId);

  @GET(path: '/user/resolve/{client_user_id}')
  Future<Response<User>> resolveUser(
      @Path('client_user_id') String clientUserId);

  static ControlPlaneService create(
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
          CreateUserResponse: CreateUserResponse.fromJson,
          DeleteUserResponse: DeleteUserResponse.fromJson,
          DeregisterProviderResponse: DeregisterProviderResponse.fromJson,
          GetAllUsersResponse: GetAllUsersResponse.fromJson,
          CreateSignInTokenResponse: CreateSignInTokenResponse.fromJson,
        }));

    return _$ControlPlaneService(client);
  }
}
