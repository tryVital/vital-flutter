import 'dart:async';

import 'package:flutter/services.dart';
import 'package:vital_core/vital_core.dart';
import 'package:vital_health_platform_interface/vital_health_platform_interface.dart';

const _channel = MethodChannel('vital_health_connect');

class VitalHealthAndroid extends VitalHealthPlatform {
  static void registerWith() {
    VitalHealthPlatform.instance = VitalHealthAndroid();
  }

  @override
  Future<void> configureClient(
      String apiKey, Region region, Environment environment) async {}

  @override
  Future<void> configureHealthkit({
    bool backgroundDeliveryEnabled = false,
    bool logsEnabled = true,
    int numberOfDaysToBackFill = 90,
    String dataPushMode = "automatic",
  }) async {}

  @override
  Future<void> setUserId(String userId) async {
    await _channel.invokeMethod('setUserId', userId);
  }

  @override
  Future<void> cleanUp() async {
    await _channel.invokeMethod('cleanUp');
  }

  @override
  Future<PermissionOutcome> askForResources(
      List<HealthkitResource> resources) async {
    throw UnimplementedError();
  }

  @override
  Future<void> syncData({List<HealthkitResource>? resources}) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> hasAskedForPermission(HealthkitResource resource) async {
    return await _channel.invokeMethod('hasAskedForPermission', resource.name)
        as bool;
  }

  @override
  Future<bool> isUserConnected(String provider) async {
    throw UnimplementedError();
  }

  @override
  Future<void> writeHealthKitData(HealthkitResourceWrite writeResource,
      DateTime startDate, DateTime endDate, double value) async {
    throw UnimplementedError();
  }

  @override
  Stream<SyncStatus> get status {
    throw UnimplementedError();
  }
}
