import 'dart:async';

import 'package:flutter/services.dart';
import 'package:vital_core_platform_interface/vital_core_platform_interface.dart';

const _channel = MethodChannel('vital_core');

class VitalCoreMethodChannel extends VitalCorePlatform {
  late final StreamController<void> _statusDidChange = StreamController(
    onListen: () async {
      await _channel.invokeMethod('subscribeToStatusChanges');
    },
    onCancel: () async {
      await _channel.invokeMethod('unsubscribeFromStatusChanges');
    },
  );

  late final _statusDidChangeBroadcast =
      _statusDidChange.stream.asBroadcastStream();

  VitalCoreMethodChannel() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "statusDidChange":
          _statusDidChange.add(null);
          break;

        default:
          break;
      }
      return null;
    });
  }

  @override
  Future<List<String>> clientStatus() {
    return _channel
        .invokeListMethod<String>("clientStatus")
        .then((value) => value ?? []);
  }

  @override
  Stream<void> clientStatusChanged() {
    return _statusDidChangeBroadcast;
  }

  @override
  Future<String?> currentUserId() {
    return _channel.invokeMethod<String>("currentUserId");
  }

  @override
  Future<void> setUserId(String userId) {
    return _channel.invokeMethod("setUserId", userId);
  }

  @override
  Future<void> configure(String apiKey, String environment, String region) {
    return _channel.invokeMethod("configure",
        {"apiKey": apiKey, "environment": environment, "region": region});
  }

  @override
  Future<void> signIn(String signInToken) {
    return _channel.invokeMethod("signIn", {"signInToken": signInToken});
  }

  @override
  Future<bool> hasUserConnectedTo(String provider) {
    return _channel.invokeMethod("hasUserConnectedTo",
        {"provider": provider}).then((value) => value as bool);
  }

  @override
  Future<String> userConnectedSources() {
    // NOTE: Native to respond with a JSON string
    return _channel
        .invokeMethod("userConnectedSources")
        .then((value) => value as String);
  }

  @override
  Future<void> createConnectedSourceIfNotExist(String provider) {
    return _channel.invokeMethod(
        "createConnectedSourceIfNotExist", {"provider": provider});
  }

  @override
  Future<void> deregisterProvider(String provider) {
    return _channel.invokeMethod("deregisterProvider", {"provider": provider});
  }

  @override
  Future<void> cleanUp() {
    return _channel.invokeMethod("cleanUp");
  }

  @override
  Future<String> getAccessToken() {
    return _channel
        .invokeMethod("getAccessToken")
        .then((value) => value as String);
  }

  @override
  Future<void> refreshToken() {
    return _channel.invokeMethod("refreshToken");
  }

  @override
  Future<String> sdkVersion() {
    return _channel
        .invokeMethod<String>("sdkVersion")
        .then((value) => value as String);
  }
}
