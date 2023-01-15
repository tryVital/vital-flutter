import 'dart:async';

import 'package:vital_core/vital_core.dart';
import 'package:vital_health_platform_interface/vital_health_platform_interface.dart';

class HealthServices {
  final String apiKey;
  final Region region;
  final Environment environment;

  HealthServices({
    required this.apiKey,
    required this.region,
    required this.environment,
  });

  Stream<SyncStatus> get status => VitalHealthPlatform.instance.status;

  Future<void> configureClient() async {
    await VitalHealthPlatform.instance
        .configureClient(apiKey, region, environment);
  }

  Future<void> configureHealth({
    HealthConfig config = const HealthConfig(),
  }) async {
    await VitalHealthPlatform.instance.configureHealth(config: config);
  }

  Future<void> setUserId(String userId) async {
    await VitalHealthPlatform.instance.setUserId(userId);
  }

  @Deprecated('Use ask() instead')
  Future<PermissionOutcome> askForResources(
      List<HealthkitResource> resources) async {
    return VitalHealthPlatform.instance.askForResources(resources);
  }

  Future<PermissionOutcome> ask(List<HealthkitResource> readResources,
      List<HealthkitResourceWrite> writeResources) async {
    return VitalHealthPlatform.instance.ask(readResources, writeResources);
  }

  Future<bool> hasAskedForPermission(HealthkitResource resource) async {
    return VitalHealthPlatform.instance.hasAskedForPermission(resource);
  }

  Future<void> syncData({List<HealthkitResource>? resources}) async {
    await VitalHealthPlatform.instance.syncData(resources: resources);
  }

  Future<bool> isUserConnected(String provider) async {
    return VitalHealthPlatform.instance.isUserConnected(provider);
  }

  Future<void> writeHealthData(HealthkitResourceWrite writeResource,
      DateTime startDate, DateTime endDate, double value) async {
    await VitalHealthPlatform.instance
        .writeHealthData(writeResource, startDate, endDate, value);
  }

  Future<void> cleanUp() async {
    await VitalHealthPlatform.instance.cleanUp();
  }
}
