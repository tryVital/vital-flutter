import 'package:vital_flutter/brand.dart';
import 'package:vital_flutter/kind.dart';

class DeviceModel {
  final String id;
  final String name;
  final Brand brand;
  final DeviceKind kind;

  const DeviceModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.kind,
  });

  @override
  String toString() {
    return 'DeviceModel{id: $id, name: $name, brand: $brand, kind: $kind}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'kind': kind,
    };
  }

  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
      id: map['id'] as String,
      name: map['name'] as String,
      brand: brandFromString(map['brand'] as String),
      kind: kindFromString(map['kind'] as String),
    );
  }
}

class ScannedDevice {
  final String id;
  final String name;
  final DeviceModel deviceModel;

  ScannedDevice({
    required this.id,
    required this.name,
    required this.deviceModel,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScannedDevice &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          deviceModel == other.deviceModel;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ deviceModel.hashCode;

  @override
  String toString() {
    return 'ScannedDevice{id: $id, name: $name, deviceModel: $deviceModel}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'deviceModel': deviceModel,
    };
  }

  factory ScannedDevice.fromMap(Map<String, dynamic> map) {
    return ScannedDevice(
      id: map['id'] as String,
      name: map['name'] as String,
      deviceModel: DeviceModel.fromMap(map['deviceModel']),
    );
  }
}
