import 'dart:io';

import 'package:disposebag/disposebag.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vital_flutter/devices/device.dart';
import 'package:vital_flutter/devices/kind.dart';
import 'package:vital_flutter/platform/data/sync_data.dart';
import 'package:vital_flutter/vital_flutter.dart';
import 'package:vital_flutter_example/utils/disposer.dart';

class DeviceBloc extends ChangeNotifier with Disposer {
  final VitalClient _client;
  final DeviceModel device;

  bool? permissionsGranted;

  bool scanning = false;
  ScannedDevice? selectedDevice;

  List<ScannedDevice> scannedDevices = [];
  List<QuantitySample> glucoseMeterResults = [];
  List<BloodPressureSample> bloodPressureMeterResults = [];

  DeviceBloc(this._client, this.device) {
    requestPermissions();
  }

  requestPermissions() {
    Permission.bluetoothConnect.request().then((value) {
      permissionsGranted = value.isGranted;
      notifyListeners();
    });
  }

  void scan() {
    scanning = true;
    _client.deviceManager.scanForDevice(device).listen((event) {
      scannedDevices.add(event);
      notifyListeners();
    }, onError: (error) {
      scanning = false;
      notifyListeners();
    }).disposedBy(disposeBag);

    notifyListeners();
  }

  void pair(BuildContext context, ScannedDevice scannedDevice) {
    _client.deviceManager.stopScan();
    scanning = false;
    selectedDevice = scannedDevice;

    _client.deviceManager.pair(scannedDevice).listen((event) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Successfully paired")));
    }, onError: (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to pair e: $error")));
    }).disposedBy(disposeBag);
  }

  readData(ScannedDevice scannedDevice) {
    _client.deviceManager.stopScan();
    scanning = false;
    selectedDevice = scannedDevice;

    switch (scannedDevice.deviceModel.kind) {
      case DeviceKind.bloodPressure:
        _client.deviceManager
            .readBloodPressureData(scannedDevice)
            .listen((event) {
          bloodPressureMeterResults.addAll(event);
          notifyListeners();
        }).disposedBy(disposeBag);
        break;
      case DeviceKind.glucoseMeter:
        _client.deviceManager
            .readGlucoseMeterData(scannedDevice)
            .listen((event) {
          glucoseMeterResults.addAll(event);
          notifyListeners();
        }).disposedBy(disposeBag);
        break;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _client.deviceManager.cleanUp();
    super.dispose();
  }
}
