// GENERATED CODE - DO NOT MODIFY BY HAND

part of vital;

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$UserService extends UserService {
  _$UserService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = UserService;

  @override
  Future<Response<GetAllUsersResponse>> getAll() {
    final $url = 'user/';
    final $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<GetAllUsersResponse, GetAllUsersResponse>($request);
  }

  @override
  Future<Response<User>> getUser(String userId) {
    final $url = 'user/${userId}';
    final $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<User, User>($request);
  }

  @override
  Future<Response<CreateUserResponse>> createUser(String clientUserId) {
    final $url = '/user/key';
    final $body = <String, dynamic>{'client_user_id': clientUserId};
    final $request = Request(
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
  Future<Response<CreateSignInTokenResponse>> createSignInToken(String userId) {
    final $url = '/user/${userId}/sign_in_token';
    final $request = Request(
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
    final $url = 'user/${userId}';
    final $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<DeleteUserResponse, DeleteUserResponse>($request);
  }

  @override
  Future<Response<User>> resolveUser(String clientUserId) {
    final $url = '/user/key/${clientUserId}';
    final $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<User, User>($request);
  }

  @override
  Future<Response<ProvidersResponse>> getProviders(String userId) {
    final $url = '/user/providers/${userId}';
    final $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<ProvidersResponse, ProvidersResponse>($request);
  }

  @override
  Future<Response<DeregisterProviderResponse>> deregisterProvider(
    String userId,
    String provider,
  ) {
    final $url = '/user/${userId}/${provider}';
    final $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client
        .send<DeregisterProviderResponse, DeregisterProviderResponse>($request);
  }

  @override
  Future<Response<RefreshResponse>> refreshUser(String userId) {
    final $url = '/user/refresh/${userId}';
    final $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<RefreshResponse, RefreshResponse>($request);
  }
}
