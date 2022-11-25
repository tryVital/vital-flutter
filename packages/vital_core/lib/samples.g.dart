// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'samples.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuantitySample _$QuantitySampleFromJson(Map<String, dynamic> json) =>
    QuantitySample(
      id: json['id'] as String?,
      value: (json['value'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      sourceBundle: json['sourceBundle'] as String?,
      type: json['type'] as String?,
      unit: json['unit'] as String,
    );

BloodPressureSample _$BloodPressureSampleFromJson(Map<String, dynamic> json) =>
    BloodPressureSample(
      systolic:
          QuantitySample.fromJson(json['systolic'] as Map<String, dynamic>),
      diastolic:
          QuantitySample.fromJson(json['diastolic'] as Map<String, dynamic>),
      pulse: json['pulse'] == null
          ? null
          : QuantitySample.fromJson(json['pulse'] as Map<String, dynamic>),
    );
