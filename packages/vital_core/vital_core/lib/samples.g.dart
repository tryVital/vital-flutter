// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'samples.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalQuantitySample _$LocalQuantitySampleFromJson(Map<String, dynamic> json) =>
    LocalQuantitySample(
      id: json['id'] as String?,
      value: (json['value'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      sourceBundle: json['sourceBundle'] as String?,
      type: json['type'] as String?,
      unit: json['unit'] as String,
    );

LocalBloodPressureSample _$LocalBloodPressureSampleFromJson(
        Map<String, dynamic> json) =>
    LocalBloodPressureSample(
      systolic: LocalQuantitySample.fromJson(
          json['systolic'] as Map<String, dynamic>),
      diastolic: LocalQuantitySample.fromJson(
          json['diastolic'] as Map<String, dynamic>),
      pulse: json['pulse'] == null
          ? null
          : LocalQuantitySample.fromJson(json['pulse'] as Map<String, dynamic>),
    );
