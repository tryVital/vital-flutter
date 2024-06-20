// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: type=lint
final class _$UserService extends UserService {
  _$UserService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = UserService;

  @override
  Future<Response<GetAllUsersResponse>> getAll() {
    final Uri $url = Uri.parse('user/');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<GetAllUsersResponse, GetAllUsersResponse>($request);
  }

  @override
  Future<Response<User>> getUser(String userId) {
    final Uri $url = Uri.parse('user/${userId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<User, User>($request);
  }

  @override
  Future<Response<CreateUserResponse>> createUser(
    String clientUserId, {
    String? fallbackTimeZone,
  }) {
    final Uri $url = Uri.parse('/user');
    final $body = <String, dynamic>{
      'client_user_id': clientUserId,
      'fallback_time_zone': fallbackTimeZone,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<CreateUserResponse, CreateUserResponse>(
      $request,
      requestConverter: JsonConverter.requestFactory,
    );
  }

  @override
  Future<Response<NoContent>> patchUser(
    String userId, {
    String? fallbackTimeZone,
  }) {
    final Uri $url = Uri.parse('/user/${userId}');
    final $body = <String, dynamic>{'fallback_time_zone': fallbackTimeZone};
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<NoContent, NoContent>(
      $request,
      requestConverter: JsonConverter.requestFactory,
    );
  }

  @override
  Future<Response<CreateSignInTokenResponse>> createSignInToken(String userId) {
    final Uri $url = Uri.parse('/user/${userId}/sign_in_token');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<CreateSignInTokenResponse, CreateSignInTokenResponse>(
      $request,
      requestConverter: JsonConverter.requestFactory,
    );
  }

  @override
  Future<Response<DeleteUserResponse>> deleteUser(String userId) {
    final Uri $url = Uri.parse('user/${userId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<DeleteUserResponse, DeleteUserResponse>($request);
  }

  @override
  Future<Response<User>> resolveUser(String clientUserId) {
    final Uri $url = Uri.parse('/user/key/${clientUserId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<User, User>($request);
  }

  @override
  Future<Response<DeregisterProviderResponse>> deregisterProvider(
    String userId,
    String provider,
  ) {
    final Uri $url = Uri.parse('/user/${userId}/${provider}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client
        .send<DeregisterProviderResponse, DeregisterProviderResponse>($request);
  }

  @override
  Future<Response<RefreshResponse>> refreshUser(String userId) {
    final Uri $url = Uri.parse('/user/refresh/${userId}');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<RefreshResponse, RefreshResponse>($request);
  }
}
