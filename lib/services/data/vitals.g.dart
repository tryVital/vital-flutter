// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vitals.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Measurement _$MeasurementFromJson(Map<String, dynamic> json) => Measurement(
      id: json['id'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      value: (json['value'] as num?)?.toDouble(),
      type: json['type'] as String?,
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$MeasurementToJson(Measurement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'value': instance.value,
      'type': instance.type,
      'unit': instance.unit,
    };
