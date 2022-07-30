import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vital_flutter/environment.dart';
import 'package:vital_flutter/platform/data/permission_outcome.dart';
import 'package:vital_flutter/platform/data/sync_data.dart';
import 'package:vital_flutter/region.dart';
import 'package:vital_flutter/vital_resource.dart';

class PlatformServices {
  var _statusSubscribed = false;
  var _configured = false;
  late final StreamController<SyncStatus> _streamController = StreamController(onListen: () async {
    _statusSubscribed = true;
    if (_configured) {
      await _channel.invokeMethod('subscribeToStatus');
    }
  }, onCancel: () async {
    _statusSubscribed = false;
    await _channel.invokeMethod('unsubscribeFromStatus');
  });
  final MethodChannel _channel;

  PlatformServices(MethodChannel channel) : _channel = channel {
    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "sendStatus":
          Fimber.d("sendStatus ${call.arguments[0]} ${call.arguments[1]} ${call.arguments[2]}");
          _streamController.sink.add(mapArgumentsToStatus(call.arguments as List<dynamic>));
          break;
        default:
          break;
      }
      return null;
    });
  }

  Future<void> configure({required String apiKey, required Region region, required Environment environment}) async {
    await _channel.invokeMethod('configure', [apiKey, region.name, environment.name]);
    if (_statusSubscribed && !_configured) {
      _configured = true;
      await _channel.invokeMethod('subscribeToStatus');
    }
  }

  Future<void> setUserId(String userId) async {
    await _channel.invokeMethod('setUserId', userId);
  }

  Future<PermissionOutcome> askForResources(List<VitalResource> resources) async {
    final outcome = await _channel.invokeMethod('askForResources', resources.map((it) => it.name).toList());
    print(outcome);
    if (outcome == null) {
      return PermissionOutcome.success();
    } else {
      return PermissionOutcome.failure('${outcome}');
    }
  }

  Future<void> syncData({List<VitalResource>? resources}) async {
    await _channel.invokeMethod('syncData', resources?.map((it) => it.name).toList());
  }

  Stream<SyncStatus> get status => _streamController.stream;
}
