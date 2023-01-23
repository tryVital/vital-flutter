import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vital_core/vital_core.dart';
import 'package:vital_health_platform_interface/vital_health_platform_interface.dart';

const _channel = MethodChannel('vital_health_connect');

class VitalHealthAndroid extends VitalHealthPlatform {
  static void registerWith() {
    VitalHealthPlatform.instance = VitalHealthAndroid();
  }

  final _statusSubject = PublishSubject<SyncStatus>();

  @override
  Future<void> configureClient(
      String apiKey, Region region, Environment environment) async {
    Fimber.d('Health Connect configure $apiKey, $region $environment');

    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "status":
          {
            _statusSubject
                .add(mapArgumentsToStatus(call.arguments as List<dynamic>));
          }
      }
    });

    await _channel.invokeMethod('configureClient', <String, dynamic>{
      "apiKey": apiKey,
      "region": region.name,
      "environment": environment.name,
    });
  }

  @override
  Future<void> configureHealth({required HealthConfig config}) async {
    Fimber.d('Health Connect configureHealthConnect');
    await _channel.invokeMethod('configureHealthConnect', <String, dynamic>{
      "logsEnabled": config.logsEnabled,
      "numberOfDaysToBackFill": config.numberOfDaysToBackFill,
      "syncOnAppStart": config.androidConfig.syncOnAppStart
    });
  }

  @override
  Future<void> setUserId(String userId) async {
    await _channel.invokeMethod('setUserId', <String, dynamic>{
      "userId": userId,
    });
  }

  @override
  Future<void> cleanUp() async {
    await _channel.invokeMethod('cleanUp');
  }

  @override
  Future<PermissionOutcome> askForResources(
      List<HealthResource> resources) async {
    return ask(resources, []);
  }

  @override
  Future<PermissionOutcome> ask(List<HealthResource> readResources,
      List<HealthResourceWrite> writeResources) async {
    final result =
        await _channel.invokeMethod('askForResources', <String, dynamic>{
      "readResources": readResources.map((e) => e.name).toList(),
      "writeResources": writeResources.map((e) => e.name).toList(),
    }) ;

    return result
        ? PermissionOutcome.success()
        : PermissionOutcome.failure(result);
  }

  @override
  Future<void> syncData({List<HealthResource>? resources}) async {
    await _channel.invokeMethod('syncData', <String, dynamic>{
      "resources": resources?.map((e) => e.name).toList(),
    });
  }

  @override
  Future<bool> hasAskedForPermission(HealthResource resource) async {
    return await _channel.invokeMethod('hasAskedForPermission', resource.name)
        as bool;
  }

  @override
  Future<bool> isUserConnected(String provider) async {
    return await _channel.invokeMethod('isUserConnected', provider) as bool;
  }

  @override
  Future<void> writeHealthData(HealthResourceWrite writeResource,
      DateTime startDate, DateTime endDate, double value) async {
    await _channel.invokeMethod('writeHealthData', <String, dynamic>{
      "resource": writeResource.name,
      "startDate": startDate.millisecondsSinceEpoch,
      "endDate": endDate.millisecondsSinceEpoch,
      "value": value,
    });
  }

  @override
  Stream<SyncStatus> get status => _statusSubject.stream;
}

SyncStatus mapArgumentsToStatus(List<dynamic> arguments) {
  switch (arguments[0] as String) {
    case 'failedSyncing':
      return SyncStatusFailed(
          HealthResource.values.firstWhere((it) => it.name == arguments[1]),
          arguments[2]);
    case 'successSyncing':
      final resource =
          HealthResource.values.firstWhere((it) => it.name == arguments[1]);
      return SyncStatusSuccessSyncing(
        resource,
        fromArgument(resource, arguments[2]),
      );
    case 'nothingToSync':
      return SyncStatusNothingToSync(
          HealthResource.values.firstWhere((it) => it.name == arguments[1]));
    case 'syncing':
      return SyncStatusSyncing(
          HealthResource.values.firstWhere((it) => it.name == arguments[1]));
    case 'syncingCompleted':
      return SyncStatusCompleted();
    default:
      return SyncStatusUnknown();
  }
}
