import 'dart:convert';
import 'dart:io';

import 'package:vital_core/client_status.dart';
import 'package:vital_core/environment.dart';
import 'package:vital_core/region.dart';
import 'package:vital_core/provider.dart';
import 'package:vital_core_platform_interface/vital_core_platform_interface.dart';

// NOTE: All methods are exposed as top-level functions, without a "VitalCore"
// namespace like the Native and React Native SDKs.
//
// > https://dart.dev/effective-dart/design#avoid-defining-a-class-that-contains-only-static-members
// > AVOID defining a class that contains only static members

Future<Set<ClientStatus>> clientStatus() {
  return VitalCorePlatform.instance.clientStatus().then((substatuses) =>
      substatuses
          .map((s) => ClientStatus.fromString(s))
          .whereType<ClientStatus>()
          .toSet());
}

Stream<Set<ClientStatus>> get clientStatusStream async* {
  yield await clientStatus();

  await for (void _ in VitalCorePlatform.instance.clientStatusChanged()) {
    yield await clientStatus();
  }
}

Future<String?> currentUserId() {
  return VitalCorePlatform.instance
      .currentUserId()
      .then((v) => v?.toLowerCase());
}

Future<void> setUserId(String userId) {
  return VitalCorePlatform.instance.setUserId(userId);
}

Future<void> configure(String apiKey, Environment environment, Region region) {
  return VitalCorePlatform.instance
      .configure(apiKey, environment.name, region.name);
}

Future<void> signIn(String signInToken) {
  return VitalCorePlatform.instance.signIn(signInToken);
}

Future<bool> hasUserConnectedTo(ProviderSlug provider) {
  return VitalCorePlatform.instance.hasUserConnectedTo(provider.toString());
}

Future<List<UserConnection>> userConnections() {
  return VitalCorePlatform.instance.userConnections().then((json) {
    List data = jsonDecode(json);
    return data.map((item) => UserConnection.fromJson(item)).toList();
  });
}

Future<void> deregisterProvider(ProviderSlug provider) {
  return VitalCorePlatform.instance.deregisterProvider(provider.toString());
}

Future<void> signOut() {
  return VitalCorePlatform.instance.signOut();
}

Future<String> getAccessToken() {
  return VitalCorePlatform.instance.getAccessToken();
}

Future<void> refreshToken() {
  return VitalCorePlatform.instance.refreshToken();
}

Future<String> sdkVersion() {
  return VitalCorePlatform.instance.sdkVersion();
}

Future<Map<String, String>> getVitalAPIHeaders() async {
  Map<String, String> headers = {};

  String versionKey;

  if (Platform.isIOS || Platform.isMacOS) {
    versionKey = "X-Vital-iOS-SDK-Version";
  } else if (Platform.isAndroid || Platform.isLinux) {
    versionKey = "X-Vital-Android-SDK-Version";
  } else {
    throw Exception(
        "Unsupported Flutter platform: ${Platform.operatingSystem}");
  }

  headers["Authorization"] = "Bearer ${await getAccessToken()}";
  headers[versionKey] = await sdkVersion();

  return headers;
}

Future<String> systemTimeZoneName() {
  return VitalCorePlatform.instance.systemTimeZoneName();
}
