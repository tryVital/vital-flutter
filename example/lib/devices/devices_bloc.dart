import 'package:flutter/material.dart';
import 'package:vital_flutter/device.dart';
import 'package:vital_flutter/kind.dart';
import 'package:vital_flutter/vital_flutter.dart';

class DevicesBloc extends ChangeNotifier {
  final VitalClient _client;

  List<DeviceModel> bloodPressureDevices = [];
  List<DeviceModel> glucoseMeterDevices = [];

  DevicesBloc(this._client) {
    for (final device in _client.deviceManager.devices) {
      if (device.kind == DeviceKind.bloodPressure) {
        bloodPressureDevices.add(device);
      } else if (device.kind == DeviceKind.glucoseMeter) {
        glucoseMeterDevices.add(device);
      }
    }
  }
}
