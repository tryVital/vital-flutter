import 'dart:async';

import 'package:vital_core/samples.dart';
import 'package:vital_devices_platform_interface/vital_devices_platform_interface.dart';

class DeviceManager {
  void init() {
    VitalDevicesPlatform.instance.init();
  }

  List<DeviceModel> getDevices(Brand brand) {
    return devices.where((element) => element.brand == brand).toList();
  }

  Future<List<ScannedDevice>> getConnectedDevices(DeviceModel deviceModel) {
    return VitalDevicesPlatform.instance.getConnectedDevices(deviceModel);
  }

  Stream<ScannedDevice> scanForDevice(DeviceModel deviceModel) {
    return VitalDevicesPlatform.instance.scanForDevice(deviceModel);
  }

  Future<void> stopScan() async {
    return VitalDevicesPlatform.instance.stopScan();
  }

  Future<bool> pair(ScannedDevice scannedDevice) {
    return VitalDevicesPlatform.instance.pair(scannedDevice);
  }

  Future<List<LocalQuantitySample>> readGlucoseMeterData(
      ScannedDevice scannedDevice) {
    return VitalDevicesPlatform.instance.readGlucoseMeterData(scannedDevice);
  }

  Future<List<LocalBloodPressureSample>> readBloodPressureData(
      ScannedDevice scannedDevice) {
    return VitalDevicesPlatform.instance.readBloodPressureData(scannedDevice);
  }

  Future<void> cleanUp() async {
    return VitalDevicesPlatform.instance.cleanUp();
  }

  final List<Brand> brands = VitalDevicesPlatform.instance.brands;
  final devices = VitalDevicesPlatform.instance.devices;
}
