import 'dart:async';

import 'package:vital_core/provider.dart';
import 'package:vital_core/vital_core.dart' as vital_core;
import 'package:vital_health_platform_interface/vital_health_platform_interface.dart';

@Deprecated("Use top-level functions in vital_health instead")
class HealthServices {
  final String apiKey;
  final vital_core.Region region;
  final vital_core.Environment environment;

  HealthServices({
    required this.apiKey,
    required this.region,
    required this.environment,
  });

  @Deprecated("Use top-level `syncStatus` in vital_health instead")
  Stream<SyncStatus> get status => VitalHealthPlatform.instance.status;

  @Deprecated("Import vital_core and use the top-level `configure` instead.")
  Future<void> configureClient() async {
    await VitalHealthPlatform.instance
        .configureClient(apiKey, region, environment);
  }

  @Deprecated("Use top-level `configure` in vital_health instead")
  Future<void> configureHealth({
    HealthConfig config = const HealthConfig(),
  }) async {
    await VitalHealthPlatform.instance.configureHealth(config: config);
  }

  @Deprecated("Import vital_core and use the top-level `setUserId` instead.")
  Future<void> setUserId(String userId) async {
    await vital_core.setUserId(userId);
  }

  @Deprecated('Use ask() instead')
  Future<PermissionOutcome> askForResources(
      List<HealthResource> resources) async {
    return await ask(resources, []);
  }

  @Deprecated("Use top-level `askForPermission` in vital_health instead")
  Future<PermissionOutcome> ask(List<HealthResource> readResources,
      List<HealthResourceWrite> writeResources) async {
    return VitalHealthPlatform.instance.ask(readResources, writeResources);
  }

  @Deprecated("Use top-level `hasAskedForPermission` in vital_health instead")
  Future<bool> hasAskedForPermission(HealthResource resource) async {
    return VitalHealthPlatform.instance.hasAskedForPermission(resource);
  }

  @Deprecated("Use top-level `syncData` in vital_health instead")
  Future<void> syncData({List<HealthResource>? resources}) async {
    await VitalHealthPlatform.instance.syncData(resources: resources);
  }

  @Deprecated(
      "Import vital_core and use the top-level `hasUserConnectedTo` instead.")
  Future<bool> isUserConnected(String provider) async {
    ProviderSlug? providerSlug = ProviderSlug.fromString(provider);
    if (providerSlug == null) {
      throw Exception("unrecognized provider slug: $provider");
    }

    return await vital_core.hasUserConnectedTo(providerSlug);
  }

  @Deprecated("Use top-level `writeHealthData` in vital_health instead")
  Future<void> writeHealthData(HealthResourceWrite writeResource,
      DateTime startDate, DateTime endDate, double value) async {
    await VitalHealthPlatform.instance
        .writeHealthData(writeResource, startDate, endDate, value);
  }

  @Deprecated("Use top-level `read` in vital_health instead")
  Future<ProcessedData?> read(
      HealthResource resource, DateTime startDate, DateTime endDate) {
    return VitalHealthPlatform.instance.read(resource, startDate, endDate);
  }

  @Deprecated("Use `vital_core.signOut()` instead")
  Future<void> cleanUp() async {
    await vital_core.signOut();
  }
}
