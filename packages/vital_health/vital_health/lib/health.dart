import 'dart:async';

import 'package:vital_core/core.dart' as vital_core;
import 'package:vital_health_platform_interface/vital_health_platform_interface.dart';

// NOTE: All methods are exposed as top-level functions, without a "VitalHealth"
// namespace like the Native and React Native SDKs.
//
// > https://dart.dev/effective-dart/design#avoid-defining-a-class-that-contains-only-static-members
// > AVOID defining a class that contains only static members

/// Health Data sync status.
/// Note that this stream does not replay any status already emitted.
Stream<SyncStatus> get syncStatus => VitalHealthPlatform.instance.status;

/// Android: Whether Health Connect is available on the current device.
/// iOS: Always return `true`.
Future<bool> isAvailable() async {
  return await VitalHealthPlatform.instance.isAvailable();
}

Future<void> configure({
  HealthConfig config = const HealthConfig(),
}) async {
  await VitalHealthPlatform.instance.configureHealth(config: config);
}

Future<PermissionOutcome> askForPermission(List<HealthResource> readResources,
    List<HealthResourceWrite> writeResources) async {
  return VitalHealthPlatform.instance.ask(readResources, writeResources);
}

Future<bool> hasAskedForPermission(HealthResource resource) async {
  return VitalHealthPlatform.instance.hasAskedForPermission(resource);
}

Future<void> syncData({List<HealthResource>? resources}) async {
  await VitalHealthPlatform.instance.syncData(resources: resources);
}

Future<void> writeHealthData(HealthResourceWrite writeResource,
    DateTime startDate, DateTime endDate, double value) async {
  await VitalHealthPlatform.instance
      .writeHealthData(writeResource, startDate, endDate, value);
}

Future<ProcessedData?> read(
    HealthResource resource, DateTime startDate, DateTime endDate) {
  return VitalHealthPlatform.instance.read(resource, startDate, endDate);
}

@Deprecated(
    "Use `vital_core.signOut()`, which now resets both Vital Core and Health SDKs.")
Future<void> cleanUp() async {
  await vital_core.signOut();
}
