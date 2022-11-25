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

  Stream<ScannedDevice> scanForDevice(DeviceModel deviceModel) {
    return VitalDevicesPlatform.instance.scanForDevice(deviceModel);
  }

  Future<void> stopScan() async {
    return VitalDevicesPlatform.instance.stopScan();
  }

  Stream<bool> pair(ScannedDevice scannedDevice) {
    return VitalDevicesPlatform.instance.pair(scannedDevice);
  }

  Stream<List<QuantitySample>> readGlucoseMeterData(
      ScannedDevice scannedDevice) {
    return VitalDevicesPlatform.instance.readGlucoseMeterData(scannedDevice);
  }

  Stream<List<BloodPressureSample>> readBloodPressureData(
      ScannedDevice scannedDevice) {
    return VitalDevicesPlatform.instance.readBloodPressureData(scannedDevice);
  }

  Future<void> cleanUp() async {
    return VitalDevicesPlatform.instance.cleanUp();
  }

  final List<Brand> brands = [
    Brand.omron,
    Brand.accuChek,
    Brand.contour,
    Brand.beurer,
    Brand.libre,
  ];

  final devices = [
    const DeviceModel(
      id: "omron_m4",
      name: "Omron Intelli IT M4",
      brand: Brand.omron,
      kind: DeviceKind.bloodPressure,
    ),
    const DeviceModel(
      id: "omron_m7",
      name: "Omron Intelli IT M7",
      brand: Brand.omron,
      kind: DeviceKind.bloodPressure,
    ),
    const DeviceModel(
      id: "accuchek_guide",
      name: "Accu-Chek Guide",
      brand: Brand.accuChek,
      kind: DeviceKind.glucoseMeter,
    ),
    const DeviceModel(
      id: "accuchek_guide_me",
      name: "Accu-Chek Guide Me",
      brand: Brand.accuChek,
      kind: DeviceKind.glucoseMeter,
    ),
    const DeviceModel(
      id: "accuchek_guide_active",
      name: "Accu-Chek Active",
      brand: Brand.accuChek,
      kind: DeviceKind.glucoseMeter,
    ),
    const DeviceModel(
      id: "contour_next_one",
      name: "Contour Next One",
      brand: Brand.contour,
      kind: DeviceKind.glucoseMeter,
    ),
    const DeviceModel(
      id: "beurer",
      name: "Beurer Devices",
      brand: Brand.beurer,
      kind: DeviceKind.bloodPressure,
    ),
    const DeviceModel(
      id: "libre1",
      name: "Freestyle Libre 1",
      brand: Brand.libre,
      kind: DeviceKind.glucoseMeter,
    ),
  ];
}
