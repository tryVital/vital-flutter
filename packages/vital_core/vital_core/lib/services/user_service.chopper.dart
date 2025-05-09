// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$UserService extends UserService {
  _$UserService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = UserService;

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
