import 'dart:async';
import 'dart:convert';

import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:vital_core/vital_core.dart';
import 'package:vital_health_platform_interface/vital_health_platform_interface.dart';

const _channel = MethodChannel('vital_health_kit');

class VitalHealthIos extends VitalHealthPlatform {
  static void registerWith() {
    VitalHealthPlatform.instance = VitalHealthIos();
  }

  late final StreamController<SyncStatus> _streamController = StreamController(
    onListen: () async {
      _statusSubscribed = true;
      if (_healthKitConfigured) {
        Fimber.d('Healthkit subscribeToStatus (stream)');
        await _channel.invokeMethod('subscribeToStatus');
      }
    },
    onCancel: () async {
      _statusSubscribed = false;
      await _channel.invokeMethod('unsubscribeFromStatus');
    },
  );

  late final _statusStream = _streamController.stream.asBroadcastStream();

  var _statusSubscribed = false;
  var _healthKitConfigured = false;

  @override
  Future<void> configureClient(
      String apiKey, Region region, Environment environment) async {
    Fimber.d('Healthkit configure $apiKey, $region $environment');

    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'sendStatus':
          Fimber.d(
              "sendStatus ${call.arguments[0]} ${call.arguments[1]} ${call.arguments[2]}");
          _streamController.sink
              .add(mapArgumentsToStatus(call.arguments as List<dynamic>));
          break;
        default:
          break;
      }
      return null;
    });

    await _channel.invokeMethod(
        'configureClient', [apiKey, region.name, environment.name]);
  }

  @override
  Future<void> configureHealthkit({
    bool backgroundDeliveryEnabled = false,
    bool logsEnabled = true,
    int numberOfDaysToBackFill = 90,
    String dataPushMode = "automatic",
  }) async {
    Fimber.d(
        'Healthkit configureHealthkit $backgroundDeliveryEnabled, $logsEnabled, $numberOfDaysToBackFill, $dataPushMode');
    await _channel.invokeMethod('configureHealthkit', [
      backgroundDeliveryEnabled,
      logsEnabled,
      numberOfDaysToBackFill,
      dataPushMode
    ]);
    _healthKitConfigured = true;
    if (_statusSubscribed) {
      Fimber.d('Healthkit subscribeToStatus (configure)');
      await _channel.invokeMethod('subscribeToStatus');
    }
  }

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
    return ask(resources, []);
  }

  @override
  Future<PermissionOutcome> ask(List<HealthkitResource> readResources,
      List<HealthkitResourceWrite> writeResources) async {
    final outcome = await _channel.invokeMethod('ask', [
      readResources.map((it) => it.name).toList(),
      writeResources.map((it) => it.name).toList()
    ]);

    if (outcome == null) {
      return PermissionOutcome.success();
    } else {
      final error = jsonDecode(outcome);
      final code = error['code'];
      final message = error['message'];
      if (code == 'healthKitNotAvailable') {
        return PermissionOutcome.healthKitNotAvailable(message);
      } else if (code == 'UnsupportedResource') {
        return PermissionOutcome.failure('Unsupported Resource: $message');
      } else {
        return PermissionOutcome.failure('Unknown error');
      }
    }
  }

  @override
  Future<void> syncData({List<HealthkitResource>? resources}) async {
    await _channel.invokeMethod(
        'syncData', resources?.map((it) => it.name).toList());
  }

  @override
  Future<bool> hasAskedForPermission(HealthkitResource resource) async {
    return await _channel.invokeMethod('hasAskedForPermission', resource.name)
        as bool;
  }

  Future<bool> isUserConnected(String provider) async {
    return await _channel.invokeMethod('isUserConnected', provider) as bool;
  }

  @override
  Future<void> writeHealthKitData(HealthkitResourceWrite writeResource,
      DateTime startDate, DateTime endDate, double value) async {
    return await _channel.invokeMethod('writeHealthKitData', [
      writeResource.name,
      value,
      startDate.millisecondsSinceEpoch,
      endDate.millisecondsSinceEpoch
    ]);
  }

  @override
  Stream<SyncStatus> get status => _statusStream;
}
