import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vital_flutter/devices/brand.dart';
import 'package:vital_flutter/devices/device.dart';
import 'package:vital_flutter/devices/kind.dart';
import 'package:vital_flutter/platform/data/sync_data.dart';

class DeviceManager {
  final MethodChannel _channel;

  final _scanSubject = PublishSubject<ScannedDevice>();
  final _glucoseReadSubject = PublishSubject<List<QuantitySample>>();
  final _bloodPressureSubject = PublishSubject<List<BloodPressureSample>>();
  final _pairSubject = PublishSubject<bool>();

  DeviceManager(
    this._channel,
  ) {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'sendScan':
          _scanSubject.sink
              .add(ScannedDevice.fromMap(jsonDecode(call.arguments as String)));
          break;
        case "sendPair":
          try {
            _pairSubject.sink
                .add((call.arguments as String).toLowerCase() == "true");
          } catch (exception, stackTrace) {
            Fimber.i(exception.toString(), stacktrace: stackTrace);
          }
          break;
        case "sendGlucoseMeterReading":
          try {
            print("aaaaaaaa");
            print(call.arguments);
            final List<dynamic> samples = jsonDecode(call.arguments as String);
            _glucoseReadSubject.sink.add(
              samples
                  .map((e) => Platform.isIOS
                      ? _sampleFromSwiftJson(e)
                      : _sampleFromJson(e))
                  .whereType<QuantitySample>()
                  .toList(),
            );
          } catch (exception, stackTrace) {
            Fimber.i(exception.toString(), stacktrace: stackTrace);
          }
          break;
        case "sendBloodPressureReading":
          try {
            final List<dynamic> samples = jsonDecode(call.arguments as String);
            _bloodPressureSubject.sink.add(
              samples
                  .map((e) => Platform.isIOS
                      ? _bloodPressureSampleFromSwiftJson(e)
                      : _bloodPressureSampleFromJson(e))
                  .whereType<BloodPressureSample>()
                  .toList(),
            );
          } catch (exception, stackTrace) {
            Fimber.i(exception.toString(), stacktrace: stackTrace);
          }
          break;
        default:
          break;
      }
      return null;
    });
  }

  List<DeviceModel> getDevices(Brand brand) {
    return devices.where((element) => element.brand == brand).toList();
  }

  Stream<ScannedDevice> scanForDevice(DeviceModel deviceModel) {
    return Stream.fromFuture(_channel.invokeMethod('startScanForDevice', [
      deviceModel.id,
      deviceModel.name,
      deviceModel.brand.name,
      deviceModel.kind.name
    ])).flatMap((outcome) {
      if (outcome == null) {
        return _scanSubject;
      } else {
        throw Exception("Could not start scan: $outcome");
      }
    });
  }

  Future<void> stopScan() async {
    return _channel.invokeMethod('stopScanForDevice');
  }

  Stream<bool> pair(ScannedDevice scannedDevice) {
    return Stream.fromFuture(_channel.invokeMethod('pair', [
      scannedDevice.id,
    ])).flatMap((outcome) {
      if (outcome == null) {
        return _pairSubject;
      } else {
        throw Exception("Couldn't pair device: $outcome");
      }
    });
  }

  Stream<List<QuantitySample>> readGlucoseMeterData(
      ScannedDevice scannedDevice) {
    return Stream.fromFuture(_channel.invokeMethod('startReadingGlucoseMeter', [
      scannedDevice.id,
    ])).flatMap((outcome) {
      if (outcome == null) {
        return _glucoseReadSubject;
      } else {
        throw Exception("Could not start scan: $outcome");
      }
    });
  }

  Stream<List<BloodPressureSample>> readBloodPressureData(
      ScannedDevice scannedDevice) {
    return Stream.fromFuture(
        _channel.invokeMethod('startReadingBloodPressure', [
      scannedDevice.id,
    ])).flatMap((outcome) {
      if (outcome == null) {
        return _bloodPressureSubject;
      } else {
        throw Exception("Could not start scan: $outcome");
      }
    });
  }

  Future<void> cleanUp() async {
    await _channel.invokeMethod('cleanUp');
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

BloodPressureSample? _bloodPressureSampleFromSwiftJson(e) {
  try {
    return BloodPressureSample(
      systolic: _sampleFromSwiftJson(e["systolic"])!,
      diastolic: _sampleFromSwiftJson(e["diastolic"])!,
      pulse: _sampleFromSwiftJson(e["pulse"]),
    );
  } catch (e) {
    print(e);
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
  } catch (e) {
    print(e);
    return null;
  }
}

QuantitySample? _sampleFromJson(Map<dynamic, dynamic> json) {
  try {
    print(json);
    return QuantitySample(
      id: json['id'] as String?,
      value: double.parse(json['value'].toString()),
      unit: json['unit'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate'] as int,
          isUtc: true),
      endDate: DateTime.fromMillisecondsSinceEpoch(json['endDate'] as int,
          isUtc: true),
      type: json['type'] as String,
    );
  } catch (e) {
    print(e);
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
  } catch (e) {
    return null;
  }
}
