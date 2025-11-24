// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'link_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$LinkService extends LinkService {
  _$LinkService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = LinkService;

  @override
  Future<Response<CreateLinkResponse>> createLink({
    required String userId,
    required String redirectUrl,
    String? provider,
    List<String>? filterOnProviders,
  }) {
    final Uri $url = Uri.parse('link/token');
    final $body = <String, dynamic>{
      'user_id': userId,
      'redirect_url': redirectUrl,
      'provider': provider,
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
  Future<Response<LinkResponse>> passwordProvider({
    required String provider,
    required String username,
    required String password,
    required String linkToken,
    String? region,
  }) {
    final Uri $url = Uri.parse('link/provider/password/${provider}');
    final Map<String, String> $headers = {
      'x-vital-link-token': linkToken,
    };
    final $body = <String, dynamic>{
      'username': username,
      'password': password,
      'region': region,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<LinkResponse, LinkResponse>(
      $request,
      requestConverter: JsonConverter.requestFactory,
    );
  }

  @override
  Future<Response<LinkResponse>> completePasswordProviderMFA({
    required String provider,
    required String mfaCode,
    required String linkToken,
  }) {
    final Uri $url =
        Uri.parse('link/provider/password/${provider}/complete_mfa');
    final Map<String, String> $headers = {
      'x-vital-link-token': linkToken,
    };
    final $body = <String, dynamic>{'mfa_code': mfaCode};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<LinkResponse, LinkResponse>(
      $request,
      requestConverter: JsonConverter.requestFactory,
    );
  }

  @override
  Future<Response<LinkResponse>> emailProvider({
    required String provider,
    required String email,
    required String linkToken,
    String? region,
  }) {
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
    return client.send<LinkResponse, LinkResponse>(
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
      'x-vital-link-token': linkToken,
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
