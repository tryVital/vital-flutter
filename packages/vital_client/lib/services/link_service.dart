library vital;

import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;
import 'package:vital_client/region.dart';
import 'package:vital_client/services/data/link.dart';
import 'package:vital_client/services/utils/http_api_key_interceptor.dart';
import 'package:vital_client/services/utils/http_logging_interceptor.dart';
import 'package:vital_client/services/utils/json_serializable_converter.dart';

part 'link_service.chopper.dart';

@ChopperApi()
abstract class LinkService extends ChopperService {
  @Post(path: 'link/token')
  @FactoryConverter(request: JsonConverter.requestFactory)
  Future<Response<CreateLinkResponse>> createLink(
    @Field('user_id') String userId,
    @Field('provider') String provider,
    @Field('redirect_url') String redirectUrl,
  );

  @Post(path: 'link/provider/password/{provider}')
  @FactoryConverter(request: JsonConverter.requestFactory)
  Future<Response<EmailProviderResponse>> passwordProvider({
    @Path('provider') required String provider,
    @Field('username') required String username,
    @Field('password') required String password,
    @Field('redirect_url') required String redirectUrl,
    @Header('LinkToken') required String linkToken,
  });

  @Post(path: 'link/provider/email/{provider}')
  @FactoryConverter(request: JsonConverter.requestFactory)
  Future<Response<EmailProviderResponse>> _emailProvider(
    @Path('provider') String provider,
    @Field('email') String email,
    @Field('region') String? region,
    @Header('x-vital-link-token') String linkToken,
  );

  Future<Response<EmailProviderResponse>> emailProvider({
    required String provider,
    required String email,
    required Region region,
    required String linkToken,
  }) {
    return _emailProvider(provider, email, region.name, linkToken);
  }

  @Get(path: 'link/provider/oauth/{provider}')
  @FactoryConverter(request: JsonConverter.requestFactory)
  Future<Response<OauthLinkResponse>> oauthProvider({
    @Path('provider') required String provider,
    @Header('LinkToken') required String linkToken,
  });

  static LinkService create(
      http.Client httpClient, String baseUrl, String apiKey) {
    final client = ChopperClient(
      client: httpClient,
      baseUrl: baseUrl,
      interceptors: [
        HttpRequestLoggingInterceptor(),
        HttpApiKeyInterceptor(apiKey)
      ],
      converter: const JsonSerializableConverter({
        CreateLinkResponse: CreateLinkResponse.fromJson,
        OauthLinkResponse: OauthLinkResponse.fromJson,
        EmailProviderResponse: EmailProviderResponse.fromJson,
      }),
    );

    return _$LinkService(client);
  }
}
