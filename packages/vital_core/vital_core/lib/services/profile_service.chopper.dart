// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: type=lint
final class _$ProfileService extends ProfileService {
  _$ProfileService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ProfileService;

  @override
  Future<Response<Profile>> getProfile(
    String userId,
    String? provider,
  ) {
    final Uri $url = Uri.parse('summary/profile/${userId}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'provider': provider
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Profile, Profile>($request);
  }

  @override
  Future<Response<Object>> getProfileRaw(
    String userId,
    String? provider,
  ) {
    final Uri $url = Uri.parse('summary/profile/${userId}/raw');
    final Map<String, dynamic> $params = <String, dynamic>{
      'provider': provider
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Object, Object>($request);
  }
}
