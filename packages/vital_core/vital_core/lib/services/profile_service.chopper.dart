// GENERATED CODE - DO NOT MODIFY BY HAND

part of vital;

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$ProfileService extends ProfileService {
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
    final $url = 'summary/profile/${userId}';
    final $params = <String, dynamic>{'provider': provider};
    final $request = Request(
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
    final $url = 'summary/profile/${userId}/raw';
    final $params = <String, dynamic>{'provider': provider};
    final $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Object, Object>($request);
  }
}
