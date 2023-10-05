import 'dart:convert';
import 'dart:io';

import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:vital_core_platform_interface/vital_core_platform_interface.dart';

const _channel = MethodChannel('vital_devices');

class VitalCoreMethodChannel extends VitalCorePlatform {
  @override
  void init() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        default:
          break;
      }
      return null;
    });
  }
}
