import 'dart:async';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:vital_core/core.dart' as vital_core;

class VitalInterceptor extends HeadersInterceptor {
  final String? apiKey;
  final bool useAccessToken;

  VitalInterceptor(this.useAccessToken, this.apiKey) : super({}) {
    if (useAccessToken && apiKey != null) {
      throw Exception("useAccessToken is true, but an API key is provided.");
    }

    if (!useAccessToken && apiKey == null) {
      throw Exception(
          "useAccessToken is false, but an API key is not provided.");
    }
  }

  @override
  Future<Request> onRequest(Request request) async {
    String versionKey, versionValue, authKey, authValue;

    if (Platform.isIOS || Platform.isMacOS) {
      versionKey = "X-Vital-iOS-SDK-Version";
      versionValue = "0.10.8";
    } else if (Platform.isAndroid || Platform.isLinux) {
      versionKey = "X-Vital-Android-SDK-Version";
      versionValue = "1.0.0-beta.23";
    } else {
      throw Exception(
          "Unsupported Flutter platform: ${Platform.operatingSystem}");
    }

    if (useAccessToken) {
      String accessToken = await vital_core.getAccessToken();
      authKey = "Authorization";
      authValue = "Bearer $accessToken";
    } else {
      authKey = "X-Vital-API-Key";
      authValue = apiKey!;
    }

    return applyHeaders(request, {
      authKey: authValue,
      versionKey: versionValue,
    });
  }
}
