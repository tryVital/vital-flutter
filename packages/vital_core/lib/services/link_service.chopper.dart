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
  Future<Response<CreateLinkResponse>> createLink(
    String userId,
    String provider,
    String redirectUrl,
  ) {
    final $url = 'link/token';
    final $body = <String, dynamic>{
      'user_id': userId,
      'provider': provider,
      'redirect_url': redirectUrl,
    };
    final $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<CreateLinkResponse, CreateLinkResponse>(
      $request,
      requestConverter: JsonConverter.requestFactory,
    );
  }

  @override
  Future<Response<EmailProviderResponse>> passwordProvider({
    required String provider,
    required String username,
    required String password,
    required String redirectUrl,
    required String linkToken,
  }) {
    final $url = 'link/provider/password/${provider}';
    final $headers = {
      'LinkToken': linkToken,
    };

    final $body = <String, dynamic>{
      'username': username,
      'password': password,
      'redirect_url': redirectUrl,
    };
    final $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<EmailProviderResponse, EmailProviderResponse>(
      $request,
      requestConverter: JsonConverter.requestFactory,
    );
  }

  @override
  Future<Response<Void>> createManualProvider(
    String userId,
    String provider,
  ) {
    final $url = 'link/provider/manual/{provider}';
    final $body = <String, dynamic>{
      'user_id': userId,
      'provider': provider,
    };
    final $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Void, Void>(
      $request,
      requestConverter: JsonConverter.requestFactory,
    );
  }

  @override
  Future<Response<EmailProviderResponse>> _emailProvider(
    String provider,
    String email,
    String? region,
    String linkToken,
  ) {
    final $url = 'link/provider/email/${provider}';
    final $headers = {
      'x-vital-link-token': linkToken,
    };

    final $body = <String, dynamic>{
      'email': email,
      'region': region,
    };
    final $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<EmailProviderResponse, EmailProviderResponse>(
      $request,
      requestConverter: JsonConverter.requestFactory,
    );
  }

  @override
  Future<Response<OauthLinkResponse>> oauthProvider({
    required String provider,
    required String linkToken,
  }) {
    final $url = 'link/provider/oauth/${provider}';
    final $headers = {
      'LinkToken': linkToken,
    };

    final $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<OauthLinkResponse, OauthLinkResponse>(
      $request,
      requestConverter: JsonConverter.requestFactory,
    );
  }
}
