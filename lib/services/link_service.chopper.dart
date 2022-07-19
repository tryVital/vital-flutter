// GENERATED CODE - DO NOT MODIFY BY HAND

part of vital;

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$LinkService extends LinkService {
  _$LinkService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = LinkService;

  @override
  Future<Response<Object>> createLink(
      String userId, String provider, String redirectUrl) {
    final $url = 'link/token';
    final $body = <String, dynamic>{
      'user_id': userId,
      'provider': provider,
      'redirect_url': redirectUrl
    };
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Object, Object>($request,
        requestConverter: JsonConverter.requestFactory);
  }

  @override
  Future<Response<Object>> passwordProvider(
      String username, String password, String redirectUrl, String linkToken) {
    final $url = 'link/provider/password/{provider}';
    final $headers = {
      'LinkToken': linkToken,
    };

    final $body = <String, dynamic>{
      'username': username,
      'password': password,
      'redirect_url': redirectUrl
    };
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<Object, Object>($request,
        requestConverter: JsonConverter.requestFactory);
  }

  @override
  Future<Response<Object>> emailProvider(
      String email, String? region, String linkToken) {
    final $url = 'link/provider/email/{provider}';
    final $headers = {
      'x-vital-link-token': linkToken,
    };

    final $body = <String, dynamic>{'email': email, 'region': region};
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<Object, Object>($request,
        requestConverter: JsonConverter.requestFactory);
  }

  @override
  Future<Response<Object>> oauthProvider(String provider, String linkToken) {
    final $url = 'link/provider/oauth/${provider}';
    final $headers = {
      'LinkToken': linkToken,
    };

    final $request = Request('POST', $url, client.baseUrl, headers: $headers);
    return client.send<Object, Object>($request,
        requestConverter: JsonConverter.requestFactory);
  }
}
