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

  DeviceState state = DeviceState.searching;
  DeviceSource? deviceSource;
  ScannedDevice? scannedDevice;

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
    Future<ConnectedOrScanned> firstConnectedOrScannedDevice =
        _deviceManager.getConnectedDevices(deviceModel).then((devices) {
      if (devices.isNotEmpty) {
        return ConnectedOrScanned(DeviceSource.paired, devices[0]);
      } else {
        return _deviceManager
            .scanForDevice(deviceModel)
            .firstWhere((event) => event.deviceModel == deviceModel)
            .then((device) {
          return ConnectedOrScanned(DeviceSource.scanned, device);
        });
      }
    });

    firstConnectedOrScannedDevice.then((result) {
      assert(result.device.deviceModel == deviceModel);
      Fimber.i(
          'Found ${result.source.name} device: ${result.device.deviceModel.name} ${result.device.id}');
      state = DeviceState.pairing;
      scannedDevice = result.device;
      deviceSource = result.source;
      readData(context, result.device);
      notifyListeners();
    });

    notifyListeners();
  }

  void pair(BuildContext context, ScannedDevice scannedDevice) {
    _deviceManager.pair(scannedDevice).then((event) {
      if (event) {
        state = DeviceState.paired;

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Successfully paired")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed to pair")));
      }

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
          state = DeviceState.paired;

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
          state = DeviceState.paired;

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

enum DeviceState {
  searching,
  pairing,
  paired,
}

extension DeviceStateExtension on DeviceState {
  String get name {
    switch (this) {
      case DeviceState.searching:
        return "Searching";
      case DeviceState.pairing:
        return "Pairing";
      case DeviceState.paired:
        return "Paired";
    }
  }
}

enum DeviceSource {
  scanned,
  paired,
}

extension DeviceSourceExtension on DeviceSource {
  String get name {
    switch (this) {
      case DeviceSource.scanned:
        return "Scanned";
      case DeviceSource.paired:
        return "Previously Paired";
    }
  }
}

class ConnectedOrScanned {
  final DeviceSource source;
  final ScannedDevice device;

  ConnectedOrScanned(this.source, this.device);
}
