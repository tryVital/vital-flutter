library vital;

import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:vital_flutter/services/data/devices.dart';
import 'package:vital_flutter/services/utils/http_api_key_interceptor.dart';
import 'package:vital_flutter/services/utils/http_logging_interceptor.dart';
import 'package:vital_flutter/services/utils/json_serializable_converter.dart';

part 'devices_service.chopper.dart';

@ChopperApi()
abstract class DevicesService extends ChopperService {
  @Get(path: '/summary/devices/{user_id}/raw')
  Future<Response<DevicesResponse>> getDevicesData(
    @Path('user_id') String userId,
    @Query('provider') String? provider,
  );

  static DevicesService create(String baseUrl, String apiKey) {
    final client = ChopperClient(
      baseUrl: baseUrl,
      interceptors: [HttpRequestLoggingInterceptor(), HttpApiKeyInterceptor(apiKey)],
      converter: const JsonSerializableConverter({
        DevicesResponse: DevicesResponse.fromJson,
      }),
    );

    return _$DevicesService(client);
  }
}
