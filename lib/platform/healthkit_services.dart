import 'dart:async';
import 'dart:convert';

import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:vital_flutter/environment.dart';
import 'package:vital_flutter/platform/data/permission_outcome.dart';
import 'package:vital_flutter/platform/data/sync_data.dart';
import 'package:vital_flutter/platform/healthkit_resource.dart';
import 'package:vital_flutter/region.dart';

abstract class HealthkitServices {
  Stream<SyncStatus> get status;

  Future<void> configureClient();

  Future<void> configureHealthkit({
    bool backgroundDeliveryEnabled = false,
    bool logsEnabled = true,
    int numberOfDaysToBackFill = 90,
    String dataPushMode = "automatic",
  });

  Future<void> setUserId(String userId);

  Future<PermissionOutcome> askForResources(List<HealthkitResource> resources);

  Future<bool> hasAskedForPermission(HealthkitResource resource);

  Future<void> syncData({List<HealthkitResource>? resources});

  Future<void> cleanUp();
}

class HealthkitServicesImpl extends HealthkitServices {
  var _statusSubscribed = false;
  var _healthKitConfigured = false;

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

  final MethodChannel _channel;
  final String _apiKey;
  final Region _region;
  final Environment _environment;

  HealthkitServicesImpl(
    MethodChannel channel, {
    required String apiKey,
    required Region region,
    required Environment environment,
  })  : _apiKey = apiKey,
        _region = region,
        _environment = environment,
        _channel = channel {
    channel.setMethodCallHandler((call) async {
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
  }

  @override
  Future<void> configureClient() async {
    Fimber.d('Healthkit configure $_apiKey, $_region $_environment');
    await _channel.invokeMethod(
        'configureClient', [_apiKey, _region.name, _environment.name]);
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
    final outcome = await _channel.invokeMethod(
        'askForResources', resources.map((it) => it.name).toList());
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
  Stream<SyncStatus> get status => _statusStream;
}

class HealthkitServicesNoop extends HealthkitServices {
  @override
  Future<PermissionOutcome> askForResources(
      List<HealthkitResource> resources) async {
    return PermissionOutcome.failure("No Op Healthkit");
  }

  @override
  Future<void> cleanUp() async {}

  @override
  Future<void> configureClient() async {}

  @override
  Future<void> configureHealthkit({
    bool backgroundDeliveryEnabled = false,
    bool logsEnabled = true,
    int numberOfDaysToBackFill = 90,
    String dataPushMode = "automatic",
  }) async {}

  @override
  Future<bool> hasAskedForPermission(HealthkitResource resource) async {
    return false;
  }

  @override
  Future<void> setUserId(String userId) async {}

  @override
  Stream<SyncStatus> get status => const Stream.empty();

  @override
  Future<void> syncData({List<HealthkitResource>? resources}) async {}
}
