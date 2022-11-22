import 'dart:io';

import 'package:disposebag/disposebag.dart';
import 'package:fimber/fimber.dart';
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

  DeviceState state = DeviceState.searching;
  ScannedDevice? scannedDevice;

  List<QuantitySample> glucoseMeterResults = [];
  List<BloodPressureSample> bloodPressureMeterResults = [];

  DeviceBloc(BuildContext context, this._client, this.device) {
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
    _client.deviceManager.scanForDevice(device).listen((event) {
      if (event.deviceModel == device) {
        Fimber.i('Found device: ${event.deviceModel.name}');
        state = DeviceState.pairing;
        scannedDevice = event;
        readData(context, event);
      }
      notifyListeners();
    }, onError: (error, stackTrace) {
      Fimber.i(error.toString(), stacktrace: stackTrace);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error scanning: $error")));
      notifyListeners();
    }).disposedBy(disposeBag);

    notifyListeners();
  }

  void pair(BuildContext context, ScannedDevice scannedDevice) {
    _client.deviceManager.pair(scannedDevice).listen((event) {
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
    }).disposedBy(disposeBag);
  }

  void readData(BuildContext context, ScannedDevice scannedDevice) {
    switch (scannedDevice.deviceModel.kind) {
      case DeviceKind.bloodPressure:
        _client.deviceManager.readBloodPressureData(scannedDevice).listen(
            (List<BloodPressureSample> newReadings) {
          state = DeviceState.paired;

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
            onError: (error, stackTrace) => _showReadingError(
                error, stackTrace, context)).disposedBy(disposeBag);
        break;
      case DeviceKind.glucoseMeter:
        _client.deviceManager.readGlucoseMeterData(scannedDevice).listen(
            (List<QuantitySample> newReadings) {
          state = DeviceState.paired;

          for (var newReading in newReadings) {
            if (!glucoseMeterResults
                .any((e) => e.startDate == newReading.startDate)) {
              glucoseMeterResults.add(newReading);
            }
          }

          glucoseMeterResults
              .sort((a, b) => b.startDate.compareTo(a.startDate));

          //We restart scanning to wait for new data
          scan(context);
          notifyListeners();
        },
            onError: (error, stackTrace) => _showReadingError(
                error, stackTrace, context)).disposedBy(disposeBag);
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
    _client.deviceManager.cleanUp();
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
