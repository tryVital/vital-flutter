library vital;

import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;
import 'package:vital_core/services/data/link.dart';
import 'package:vital_core/services/utils/http_logging_interceptor.dart';
import 'package:vital_core/services/utils/json_serializable_converter.dart';

part 'link_service.chopper.dart';

@ChopperApi()
abstract class LinkService extends ChopperService {
  @Post(path: 'link/token')
  @FactoryConverter(request: JsonConverter.requestFactory)
  Future<Response<CreateLinkResponse>> createLink(
      {@Field('user_id') required String userId,
      @Field('redirect_url') required String redirectUrl,
      @Field('provider') String? provider,
      @Field('filter_on_providers') List<String>? filterOnProviders});

  @Post(path: 'link/provider/password/{provider}')
  @FactoryConverter(request: JsonConverter.requestFactory)
  Future<Response<LinkResponse>> passwordProvider({
    @Path('provider') required String provider,
    @Field('username') required String username,
    @Field('password') required String password,
    @Header('x-vital-link-token') required String linkToken,
    @Field('region') String? region,
  });

  @Post(path: 'link/provider/password/{provider}/complete_mfa')
  @FactoryConverter(request: JsonConverter.requestFactory)
  Future<Response<LinkResponse>> completePasswordProviderMFA({
    @Path('provider') required String provider,
    @Field('mfa_code') required String mfaCode,
    @Header('x-vital-link-token') required String linkToken,
  });

  @Post(path: 'link/provider/email/{provider}')
  @FactoryConverter(request: JsonConverter.requestFactory)
  Future<Response<LinkResponse>> emailProvider({
    @Path('provider') required String provider,
    @Field('email') required String email,
    @Header('x-vital-link-token') required String linkToken,
    @Field('region') String? region,
  });

  @Get(path: 'link/provider/oauth/{provider}')
  @FactoryConverter(request: JsonConverter.requestFactory)
  Future<Response<OauthLinkResponse>> oauthProvider({
    @Path('provider') required String provider,
    @Header('x-vital-link-token') required String linkToken,
  });

  @Get(
      path: 'link/connect/{provider}',
      headers: {"X-Vital-SDK-No-Redirect": "1"})
  @FactoryConverter(request: JsonConverter.requestFactory)
  Future<Response<NoContent>> exchangeOAuthCode({
    @Path('provider') required String provider,
    @Query('code') required String code,
    @Query('state') required String linkToken,
  });

  @Post(path: 'link/token/isValid')
  Future<Response<NoContent>> isTokenValid({
    @Body() required IsLinkTokenValidRequest request,
  });

  static LinkService create(
      http.Client httpClient, Uri baseUrl, RequestInterceptor authInterceptor) {
    final client = ChopperClient(
      client: httpClient,
      baseUrl: baseUrl,
      interceptors: [
        HttpRequestLoggingInterceptor(),
        authInterceptor,
      ],
      converter: const JsonSerializableConverter({
        CreateLinkResponse: CreateLinkResponse.fromJson,
        OauthLinkResponse: OauthLinkResponse.fromJson,
        LinkResponse: LinkResponse.fromJson,
      }),
    );

    return _$LinkService(client);
  }
}
