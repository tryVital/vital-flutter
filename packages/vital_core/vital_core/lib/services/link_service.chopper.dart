// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: type=lint
final class _$LinkService extends LinkService {
  _$LinkService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = LinkService;

  @override
  Future<Response<CreateLinkResponse>> createLink(
    String userId,
    String? provider,
    String redirectUrl, {
    List<String>? filterOnProviders,
  }) {
    final Uri $url = Uri.parse('link/token');
    final $body = <String, dynamic>{
      'user_id': userId,
      'provider': provider,
      'redirect_url': redirectUrl,
      'filter_on_providers': filterOnProviders,
    };
    final Request $request = Request(
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
    final Uri $url = Uri.parse('link/provider/password/${provider}');
    final Map<String, String> $headers = {
      'LinkToken': linkToken,
    };
    final $body = <String, dynamic>{
      'username': username,
      'password': password,
      'redirect_url': redirectUrl,
    };
    final Request $request = Request(
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
    final Uri $url = Uri.parse('link/provider/manual/{provider}');
    final $body = <String, dynamic>{
      'user_id': userId,
      'provider': provider,
    };
    final Request $request = Request(
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
    final Uri $url = Uri.parse('link/provider/email/${provider}');
    final Map<String, String> $headers = {
      'x-vital-link-token': linkToken,
    };
    final $body = <String, dynamic>{
      'email': email,
      'region': region,
    };
    final Request $request = Request(
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
    final Uri $url = Uri.parse('link/provider/oauth/${provider}');
    final Map<String, String> $headers = {
      'LinkToken': linkToken,
    };
    final Request $request = Request(
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

  @override
  Future<Response<NoContent>> exchangeOAuthCode({
    required String provider,
    required String code,
    required String linkToken,
  }) {
    final Uri $url = Uri.parse('link/connect/${provider}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'code': code,
      'state': linkToken,
    };
    final Map<String, String> $headers = {
      'X-Vital-SDK-No-Redirect': '1',
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      headers: $headers,
    );
    return client.send<NoContent, NoContent>(
      $request,
      requestConverter: JsonConverter.requestFactory,
    );
  }

  @override
  Future<Response<NoContent>> isTokenValid(
      {required IsLinkTokenValidRequest request}) {
    final Uri $url = Uri.parse('link/token/isValid');
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<NoContent, NoContent>($request);
  }
}
