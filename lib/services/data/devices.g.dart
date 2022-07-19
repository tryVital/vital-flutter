// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevicesResponse _$DevicesResponseFromJson(Map<String, dynamic> json) =>
    DevicesResponse(
      devices: (json['devices'] as List<dynamic>?)
              ?.map((e) => DeviceData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DevicesResponseToJson(DevicesResponse instance) =>
    <String, dynamic>{
      'devices': instance.devices,
    };

DeviceData _$DeviceDataFromJson(Map<String, dynamic> json) => DeviceData(
      userId: json['user_id'] as String?,
      providerId: json['provider_id'] as String?,
      sourceId: json['source_id'] as String?,
      id: json['id'] as String,
      data: json['data'] == null
          ? null
          : DeviceReading.fromJson(json['data'] as Map<String, dynamic>),
      source: Source.fromJson(json['source'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeviceDataToJson(DeviceData instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'provider_id': instance.providerId,
      'source_id': instance.sourceId,
      'id': instance.id,
      'data': instance.data,
      'source': instance.source,
    };

DeviceReading _$DeviceReadingFromJson(Map<String, dynamic> json) =>
    DeviceReading(
      lastReading: json['last_reading'] == null
          ? null
          : DateTime.parse(json['last_reading'] as String),
      firstReading: json['first_reading'] == null
          ? null
          : DateTime.parse(json['first_reading'] as String),
      serialNumber: json['serial_number'] as String?,
    );

Map<String, dynamic> _$DeviceReadingToJson(DeviceReading instance) =>
    <String, dynamic>{
      'last_reading': instance.lastReading?.toIso8601String(),
      'first_reading': instance.firstReading?.toIso8601String(),
      'serial_number': instance.serialNumber,
    };
