import 'dart:io' show Platform;

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vital_core/samples.dart';
import 'package:vital_devices_platform_interface/src/brand.dart';
import 'package:vital_devices_platform_interface/src/device.dart';
import 'package:vital_devices_platform_interface/src/kind.dart';
import 'package:vital_devices_platform_interface/src/vital_devices_method_channel.dart';

class VitalDevicesPlatform extends PlatformInterface {
  static final Object _token = Object();

  VitalDevicesPlatform() : super(token: _token);

  static VitalDevicesPlatform _instance = VitalDevicesMethodChannel();

  static set instance(VitalDevicesPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  static VitalDevicesPlatform get instance => _instance;

  void init() {
    throw UnimplementedError('init() has not been implemented.');
  }

  List<DeviceModel> getDevices(Brand brand) =>
      throw UnimplementedError('getDevices() has not been implemented.');

  Future<List<ScannedDevice>> getConnectedDevices(DeviceModel deviceModel) =>
      throw UnimplementedError(
          'getConnectedDevices() has not been implemented.');

  Stream<ScannedDevice> scanForDevice(DeviceModel deviceModel) =>
      throw UnimplementedError('scanForDevice() has not been implemented.');

  Future<void> stopScan() async =>
      throw UnimplementedError('stopScan() has not been implemented.');

  Future<bool> pair(ScannedDevice scannedDevice) =>
      throw UnimplementedError('pair() has not been implemented.');

  Future<List<LocalQuantitySample>> readGlucoseMeterData(
          ScannedDevice scannedDevice) =>
      throw UnimplementedError(
          'readGlucoseMeterData() has not been implemented.');

  Future<List<LocalBloodPressureSample>> readBloodPressureData(
          ScannedDevice scannedDevice) =>
      throw UnimplementedError(
          'readBloodPressureData() has not been implemented.');

  Future<void> cleanUp() async =>
      throw UnimplementedError('cleanUp() has not been implemented.');
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
    DeviceModel(
      id: Platform.isIOS ? "\$vital_ble_simulator\$" : "_vital_ble_simulator_",
      name: "Vital BLE Simulator",
      brand: Brand.accuChek,
      kind: DeviceKind.glucoseMeter,
    ),
    // TODO: VIT-4957 Flutter SDK: Expose Libre1 Reader
    //
    // const DeviceModel(
    //   id: "libre1",
    //   name: "Freestyle Libre 1",
    //   brand: Brand.libre,
    //   kind: DeviceKind.glucoseMeter,
    // ),
  ];
}
