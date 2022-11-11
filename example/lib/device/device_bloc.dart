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
    if (Platform.isAndroid) {
      Permission.bluetoothScan.request().then((value) {
        permissionsGranted = value.isGranted;
        notifyListeners();
      });
    } else {
      permissionsGranted = true;
      notifyListeners();
    }
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
