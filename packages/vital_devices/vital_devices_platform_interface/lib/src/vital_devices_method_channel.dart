import 'dart:convert';
import 'dart:io';

import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vital_core/samples.dart';
import 'package:vital_devices_platform_interface/src/brand.dart';
import 'package:vital_devices_platform_interface/src/device.dart';
import 'package:vital_devices_platform_interface/src/exception.dart';
import 'package:vital_devices_platform_interface/src/vital_devices_platform.dart';

const _channel = MethodChannel('vital_devices');

class VitalDevicesMethodChannel extends VitalDevicesPlatform {
  final _scanSubject = PublishSubject<ScannedDevice>();
  final _glucoseReadSubject = PublishSubject<List<QuantitySample>>();
  final _bloodPressureSubject = PublishSubject<List<BloodPressureSample>>();
  final _pairSubject = PublishSubject<bool>();

  @override
  void init() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'sendScan':
          try {
            final decodedArguments = jsonDecode(call.arguments as String);
            final error = _mapError(decodedArguments);

            if (error != null) {
              _scanSubject.addError(error);
            } else {
              _scanSubject.sink.add(ScannedDevice.fromMap(decodedArguments));
            }
          } catch (exception, stackTrace) {
            Fimber.i(exception.toString(), stacktrace: stackTrace);
            _scanSubject.addError(UnknownException("$exception $stackTrace"));
          }
          break;
        case "sendPair":
          try {
            final decodedArguments = jsonDecode(call.arguments as String);
            final error = _mapError(decodedArguments);

            if (error != null) {
              _scanSubject.addError(error);
            } else {
              _pairSubject.sink
                  .add((call.arguments as String).toLowerCase() == "true");
            }
          } catch (exception, stackTrace) {
            Fimber.i(exception.toString(), stacktrace: stackTrace);
            _scanSubject.addError(UnknownException("$exception $stackTrace"));
          }
          break;
        case "sendGlucoseMeterReading":
          try {
            final decodedArguments = jsonDecode(call.arguments as String);
            final error = _mapError(decodedArguments);

            if (error != null) {
              _scanSubject.addError(error);
            } else {
              _glucoseReadSubject.sink.add(
                decodedArguments
                    .map((e) => Platform.isIOS
                        ? _sampleFromSwiftJson(e)
                        : _sampleFromJson(e))
                    .whereType<QuantitySample>()
                    .toList(),
              );
            }
          } catch (exception, stackTrace) {
            Fimber.i(exception.toString(), stacktrace: stackTrace);
            _scanSubject.addError(UnknownException("$exception $stackTrace"));
          }
          break;
        case "sendBloodPressureReading":
          try {
            final decodedArguments = jsonDecode(call.arguments as String);
            final error = _mapError(decodedArguments);

            if (error != null) {
              _scanSubject.addError(error);
            } else {
              _bloodPressureSubject.sink.add(
                decodedArguments
                    .map((e) => Platform.isIOS
                        ? _bloodPressureSampleFromSwiftJson(e)
                        : _bloodPressureSampleFromJson(e))
                    .whereType<BloodPressureSample>()
                    .toList(),
              );
            }
          } catch (exception, stackTrace) {
            Fimber.i(exception.toString(), stacktrace: stackTrace);
            _scanSubject.addError(UnknownException("$exception $stackTrace"));
          }
          break;
        default:
          break;
      }
      return null;
    });
  }

  @override
  List<DeviceModel> getDevices(Brand brand) {
    return devices.where((element) => element.brand == brand).toList();
  }

  @override
  Stream<ScannedDevice> scanForDevice(DeviceModel deviceModel) {
    return Stream.fromFuture(
      _checkPermissions().then(
        (value) => _channel.invokeMethod('startScanForDevice', [
          deviceModel.id,
          deviceModel.name,
          deviceModel.brand.name,
          deviceModel.kind.name
        ]),
      ),
    ).flatMap((outcome) {
      if (outcome == null) {
        return _scanSubject;
      } else {
        throw UnknownException("Could not start scan: $outcome");
      }
    });
  }

  @override
  Future<void> stopScan() async {
    return _channel.invokeMethod('stopScanForDevice');
  }

  @override
  Stream<bool> pair(ScannedDevice scannedDevice) {
    return Stream.fromFuture(
      _checkPermissions().then(
        (value) => _channel.invokeMethod('pair', [scannedDevice.id]),
      ),
    ).flatMap((outcome) {
      if (outcome == null) {
        return _pairSubject;
      } else {
        throw UnknownException("Couldn't pair device: $outcome");
      }
    });
  }

  @override
  Stream<List<QuantitySample>> readGlucoseMeterData(
      ScannedDevice scannedDevice) {
    return Stream.fromFuture(
      _checkPermissions().then(
        (value) => _channel
            .invokeMethod('startReadingGlucoseMeter', [scannedDevice.id]),
      ),
    ).flatMap((outcome) {
      if (outcome == null) {
        return _glucoseReadSubject;
      } else {
        throw UnknownException("Could not start scan: $outcome");
      }
    });
  }

  @override
  Stream<List<BloodPressureSample>> readBloodPressureData(
      ScannedDevice scannedDevice) {
    return Stream.fromFuture(
      _checkPermissions().then(
        (value) => _channel
            .invokeMethod('startReadingBloodPressure', [scannedDevice.id]),
      ),
    ).flatMap((outcome) {
      if (outcome == null) {
        return _bloodPressureSubject;
      } else {
        throw Exception("Could not start scan: $outcome");
      }
    });
  }

  @override
  Future<void> cleanUp() async {
    await _channel.invokeMethod('cleanUp');
  }

  Future<void> _checkPermissions() async {
    if (Platform.isIOS) {
      final permissionGranted =
          await Permission.bluetooth.status == PermissionStatus.granted;
      if (!permissionGranted) {
        throw MissingPermissionException("Bluetooth permission not granted");
      }
    } else if (Platform.isAndroid) {
      final scanPermissionGranted =
          await Permission.bluetoothScan.status == PermissionStatus.granted;

      if (!scanPermissionGranted) {
        throw MissingPermissionException(
            "Bluetooth Scan permission not granted");
      }

      final bluetoothConnectPermissionGranted =
          await Permission.bluetoothConnect.status == PermissionStatus.granted;

      if (!bluetoothConnectPermissionGranted) {
        throw MissingPermissionException(
            "Bluetooth Connect permission not granted");
      }
    }
  }

  DeviceManagerExceptions? _mapError(dynamic arguments) {
    if (arguments is! Map) return null;

    final code = arguments.containsKey("code") ? arguments["code"] : null;
    final message =
        arguments.containsKey("message") ? arguments["message"] : null;

    if (code == null || message == null) {
      return null;
    } else {
      switch (code) {
        case "PairError":
          return PairErrorException(message);
        case "DeviceNotFound":
          return DeviceNotFoundException(message);
        case "UnsupportedRegion":
          return UnsupportedRegionException(message);
        case "UnsupportedEnvironment":
          return UnsupportedEnvironmentException(message);
        case "UnsupportedBrand":
          return UnsupportedBrandException(message);
        case "UnsupportedKind":
          return UnsupportedKindException(message);
      }

      return UnknownException(code + " " + message);
    }
  }
}

BloodPressureSample? _bloodPressureSampleFromSwiftJson(e) {
  try {
    return BloodPressureSample(
      systolic: _sampleFromSwiftJson(e["systolic"])!,
      diastolic: _sampleFromSwiftJson(e["diastolic"])!,
      pulse: _sampleFromSwiftJson(e["pulse"]),
    );
  } catch (e, stacktrace) {
    Fimber.i("Error parsing sample: $e $stacktrace");
    return null;
  }
}

BloodPressureSample? _bloodPressureSampleFromJson(e) {
  try {
    return BloodPressureSample(
      systolic: _sampleFromJson(e["systolic"])!,
      diastolic: _sampleFromJson(e["diastolic"])!,
      pulse: _sampleFromJson(e["pulse"]),
    );
  } catch (e, stacktrace) {
    Fimber.i("Error parsing sample: $e $stacktrace");
    return null;
  }
}

QuantitySample? _sampleFromJson(Map<dynamic, dynamic> json) {
  try {
    return QuantitySample(
      id: json['id'] as String?,
      value: double.parse(json['value'].toString()),
      unit: json['unit'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate'] as int,
          isUtc: true),
      endDate: DateTime.fromMillisecondsSinceEpoch(json['endDate'] as int,
          isUtc: true),
      type: json['type'] as String?,
    );
  } catch (e, stacktrace) {
    Fimber.i("Error parsing sample: $e $stacktrace");
    return null;
  }
}

final _swiftTimeStart = DateTime.utc(2001, 1, 1, 0, 0, 0, 0, 0);

QuantitySample? _sampleFromSwiftJson(Map<dynamic, dynamic> json) {
  try {
    final startMillisecondsSinceEpoch = (json['startDate'] as int) * 1000;
    final endMillisecondsSinceEpoch = (json['endDate'] as int) * 1000;

    return QuantitySample(
      id: json['id'] as String?,
      value: double.parse(json['value'].toString()),
      unit: json['unit'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(
          _swiftTimeStart.millisecondsSinceEpoch + startMillisecondsSinceEpoch),
      endDate: DateTime.fromMillisecondsSinceEpoch(
          _swiftTimeStart.millisecondsSinceEpoch + endMillisecondsSinceEpoch),
      type: json['type'] as String,
    );
  } catch (e, stacktrace) {
    Fimber.i("Error parsing sample: $e $stacktrace");
    return null;
  }
}
