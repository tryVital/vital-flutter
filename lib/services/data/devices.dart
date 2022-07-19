import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'devices.g.dart';

@JsonSerializable()
class DevicesResponse {
  List<DeviceData> devices;

  DevicesResponse({
    this.devices = const [],
  });

  factory DevicesResponse.fromJson(Map<String, dynamic> json) => _$DevicesResponseFromJson(json);
}

@JsonSerializable()
class DeviceData {
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'provider_id')
  String? providerId;
  @JsonKey(name: 'source_id')
  String? sourceId;
  String id;
  DeviceReading? data;
  Source source;

  DeviceData({
    this.userId,
    this.providerId,
    this.sourceId,
    required this.id,
    this.data,
    required this.source,
  });

  factory DeviceData.fromJson(Map<String, dynamic> json) => _$DeviceDataFromJson(json);
}

@JsonSerializable()
class DeviceReading {
  @JsonKey(name: 'last_reading')
  DateTime? lastReading;
  @JsonKey(name: 'first_reading')
  DateTime? firstReading;
  @JsonKey(name: 'serial_number')
  String? serialNumber;

  DeviceReading({
    this.lastReading,
    this.firstReading,
    this.serialNumber,
  });

  factory DeviceReading.fromJson(Map<String, dynamic> json) => _$DeviceReadingFromJson(json);
}
