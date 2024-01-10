library vital;

import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:vital_core/services/data/providers.dart';
import 'package:vital_core/services/utils/http_logging_interceptor.dart';
import 'package:vital_core/services/utils/json_serializable_converter.dart';
import 'package:http/http.dart' as http;

part 'providers_service.chopper.dart';

@ChopperApi()
abstract class ProvidersService extends ChopperService {
  @Get(path: 'providers')
  Future<Response<List<AvailableProvider>>> get();

  static ProvidersService create(
      http.Client httpClient, Uri baseUrl, RequestInterceptor authInterceptor) {
    final client = ChopperClient(
      client: httpClient,
      baseUrl: baseUrl,
      interceptors: [
        HttpRequestLoggingInterceptor(),
        authInterceptor,
      ],
      converter: const JsonSerializableConverter({
        AvailableProvider: AvailableProvider.fromJson,
      }),
    );

    return _$ProvidersService(client);
  }
}
