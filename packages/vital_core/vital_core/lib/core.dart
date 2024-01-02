import 'dart:convert';

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

Stream<Set<ClientStatus>> get clientStatusStream {
  return VitalCorePlatform.instance
      .clientStatusChanged()
      .asyncMap((event) => clientStatus());
}

Future<String?> currentUserId() {
  return VitalCorePlatform.instance.currentUserId();
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

Future<List<VitalProvider>> userConnectedSources() {
  return VitalCorePlatform.instance.userConnectedSources().then((json) {
    List data = jsonDecode(json);
    return data.map((item) => VitalProvider.fromJson(item)).toList();
  });
}

Future<void> createConnectedSourceIfNotExist(ManualProviderSlug provider) {
  return VitalCorePlatform.instance
      .createConnectedSourceIfNotExist(provider.toString());
}

Future<void> deregisterProvider(ProviderSlug provider) {
  return VitalCorePlatform.instance.deregisterProvider(provider.toString());
}

Future<void> cleanUp() {
  return VitalCorePlatform.instance.cleanUp();
}

Future<String> getAccessToken() {
  return VitalCorePlatform.instance.getAccessToken();
}

Future<void> refreshToken() {
  return VitalCorePlatform.instance.refreshToken();
}
