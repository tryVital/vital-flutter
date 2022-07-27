import 'package:flutter/services.dart';
import 'package:vital_flutter/region.dart';

class PlatformServices {
  final MethodChannel _channel;

  PlatformServices(MethodChannel channel) : _channel = channel;

  Future<bool> configure(String apiKey, Region region) async {
    await _channel.invokeMethod('configure', [apiKey, region.name]);
    return true;
  }

  Future<bool> setUserId(String userId) async {
    await _channel.invokeMethod('setUserId', userId);
    return true;
  }

  Future<bool> askForResources() async {
    await _channel.invokeMethod('askForResources');
    return true;
  }

  Future<bool> syncData() async {
    await _channel.invokeMethod('syncData');
    return true;
  }
}
