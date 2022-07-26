import 'dart:async';

import 'package:flutter/services.dart';
export 'region.dart';
export 'vital_client.dart';

class VitalFlutter {
  static const MethodChannel _channel = MethodChannel('vital_flutter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
