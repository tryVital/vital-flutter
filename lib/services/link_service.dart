library vital;

import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:vital_flutter/services/utils/http_api_key_interceptor.dart';
import 'package:vital_flutter/services/utils/http_logging_interceptor.dart';

part 'link_service.chopper.dart';

@ChopperApi()
abstract class LinkService extends ChopperService {
  @Post(path: 'link/token')
  @FactoryConverter(request: JsonConverter.requestFactory)
  Future<Response<Object>> createLink(
    @Field('user_id') String userId,
    @Field('provider') String provider,
    @Field('redirect_url') String redirectUrl,
  );

  @Post(path: 'link/provider/password/{provider}')
  @FactoryConverter(request: JsonConverter.requestFactory)
  Future<Response<Object>> passwordProvider(
    @Field('username') String username,
    @Field('password') String password,
    @Field('redirect_url') String redirectUrl,
    @Header('LinkToken') String linkToken,
  );

  @Post(path: 'link/provider/email/{provider}')
  @FactoryConverter(request: JsonConverter.requestFactory)
  Future<Response<Object>> emailProvider(
    @Field('email') String email,
    @Field('region') String? region,
    @Header('x-vital-link-token') String linkToken,
  );

  @Post(path: 'link/provider/oauth/{provider}')
  @FactoryConverter(request: JsonConverter.requestFactory)
  Future<Response<Object>> oauthProvider(
    @Path('provider') String provider,
    @Header('LinkToken') String linkToken, //TODO: Check if "LinkToken" or "x-vital..."
  );

  static LinkService create(String baseUrl, String apiKey) {
    final client = ChopperClient(
      baseUrl: baseUrl,
      interceptors: [HttpRequestLoggingInterceptor(), HttpApiKeyInterceptor(apiKey)],
    );

    return _$LinkService(client);
  }
}
