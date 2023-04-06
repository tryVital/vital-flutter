import 'dart:async';
import 'dart:io';

import 'package:disposebag/disposebag.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vital_core/samples.dart';
import 'package:vital_devices/vital_devices.dart';
import 'package:vital_flutter_example/utils/disposer.dart';

class DeviceBloc extends ChangeNotifier with Disposer {
  final DeviceManager _deviceManager;
  final DeviceModel deviceModel;

  bool isScanning = false;
  StreamSubscription? scanSubscription;

  List<ScannedDevice> connectedDevices = [];
  List<ScannedDevice> scannedDevices = [];
  List<QuantitySample> glucoseMeterResults = [];
  List<BloodPressureSample> bloodPressureMeterResults = [];

  DeviceBloc(BuildContext context, this._deviceManager, this.deviceModel) {
    _deviceManager.init();
    requestPermissions();
    scan(context);
  }

  void requestPermissions() async {
    if (Platform.isIOS) {
      await Permission.bluetooth.request();
    } else {
      await Permission.bluetoothScan.request();
      await Permission.bluetoothConnect.request();
    }
  }

  void scan(BuildContext context) {
    _deviceManager.getConnectedDevices(deviceModel).then((devices) {
      connectedDevices = devices;
      notifyListeners();
    });

    scanSubscription =
        _deviceManager.scanForDevice(deviceModel).listen((newDevice) {
      if (!scannedDevices.contains(newDevice)) {
        scannedDevices.add(newDevice);
        notifyListeners();
      }
    }, onError: (error) {
      Fimber.i('Error when scanning for device: $error');
    });

    notifyListeners();
  }

  void stopScanning(BuildContext context) {
    scanSubscription?.cancel();
    scanSubscription = null;
    notifyListeners();
  }

  void pair(BuildContext context, ScannedDevice scannedDevice) {
    Fimber.i('Request to pair device: ${scannedDevice.deviceModel.name}');

    _deviceManager.pair(scannedDevice).then((event) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Successfully paired")));
      Fimber.i('Successfully paired device: ${scannedDevice.deviceModel.name}');

      notifyListeners();
    }, onError: (error, stackTrace) {
      Fimber.i(error.toString(), stacktrace: stackTrace);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to pair e: $error")));
    });
  }

  void readData(BuildContext context, ScannedDevice scannedDevice) {
    Fimber.i(
        'Request to read data from device: ${scannedDevice.deviceModel.name}');

    switch (scannedDevice.deviceModel.kind) {
      case DeviceKind.bloodPressure:
        // `readBloodPressureData` delivers all data in one batch, and then completes.
        _deviceManager.readBloodPressureData(scannedDevice).then(
            (List<BloodPressureSample> newReadings) {
          Fimber.i(
              'Received ${newReadings.length} samples from device: ${scannedDevice.deviceModel.name}');

          for (var newReading in newReadings) {
            if (!bloodPressureMeterResults.any((e) =>
                e.diastolic.startDate == newReading.diastolic.startDate)) {
              bloodPressureMeterResults.add(newReading);
            }

            bloodPressureMeterResults.sort((a, b) =>
                b.diastolic.startDate.compareTo(a.diastolic.startDate));
          }

          notifyListeners();
        },
            onError: (error, stackTrace) =>
                _showReadingError(error, stackTrace, context));
        break;
      case DeviceKind.glucoseMeter:
        _deviceManager.readGlucoseMeterData(scannedDevice).then(
            (List<QuantitySample> newReadings) {
          Fimber.i(
              'Received ${newReadings.length} samples from device: ${scannedDevice.deviceModel.name}');

          for (var newReading in newReadings) {
            if (!glucoseMeterResults
                .any((e) => e.startDate == newReading.startDate)) {
              glucoseMeterResults.add(newReading);
            }
          }

          glucoseMeterResults
              .sort((a, b) => b.startDate.compareTo(a.startDate));

          notifyListeners();
        },
            onError: (error, stackTrace) =>
                _showReadingError(error, stackTrace, context));
        break;
    }

    notifyListeners();
  }

  void _showReadingError(error, stackTrace, BuildContext context) {
    Fimber.i(error.toString(), stacktrace: stackTrace);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Failed to read data e: $error")));
  }

  @override
  void dispose() {
    _deviceManager.cleanUp();
    super.dispose();
  }
}
