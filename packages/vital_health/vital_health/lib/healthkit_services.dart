import 'dart:async';

import 'package:vital_core/vital_core.dart';
import 'package:vital_health_platform_interface/vital_health_platform_interface.dart';

class HealthkitServices {
  final String apiKey;
  final Region region;
  final Environment environment;

  HealthkitServices({
    required this.apiKey,
    required this.region,
    required this.environment,
  });

  Stream<SyncStatus> get status => VitalHealthPlatform.instance.status;

  Future<void> configureClient() async {
    await VitalHealthPlatform.instance
        .configureClient(apiKey, region, environment);
  }

  Future<void> configureHealthkit({
    bool backgroundDeliveryEnabled = false,
    bool logsEnabled = true,
    int numberOfDaysToBackFill = 90,
    String dataPushMode = "automatic",
  }) async {
    await VitalHealthPlatform.instance.configureHealthkit(
      backgroundDeliveryEnabled: backgroundDeliveryEnabled,
      logsEnabled: logsEnabled,
      numberOfDaysToBackFill: numberOfDaysToBackFill,
      dataPushMode: dataPushMode,
    );
  }

  Future<void> setUserId(String userId) async {
    await VitalHealthPlatform.instance.setUserId(userId);
  }

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

  Future<void> writeHealthKitData(HealthkitResourceWrite writeResource,
      DateTime startDate, DateTime endDate, double value) async {
    await VitalHealthPlatform.instance
        .writeHealthKitData(writeResource, startDate, endDate, value);
  }

  Future<void> cleanUp() async {
    await VitalHealthPlatform.instance.cleanUp();
  }
}
