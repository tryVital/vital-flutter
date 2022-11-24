import 'package:flutter/material.dart';
import 'package:vital_devices/vital_devices.dart';

class DevicesBloc extends ChangeNotifier {
  final DeviceManager _deviceManager;

  List<DeviceModel> bloodPressureDevices = [];
  List<DeviceModel> glucoseMeterDevices = [];

  DevicesBloc(this._deviceManager) {
    for (final device in _deviceManager.devices) {
      if (device.kind == DeviceKind.bloodPressure) {
        bloodPressureDevices.add(device);
      } else if (device.kind == DeviceKind.glucoseMeter) {
        glucoseMeterDevices.add(device);
      }
    }
  }
}
