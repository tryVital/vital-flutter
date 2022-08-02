// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivitySummary _$ActivitySummaryFromJson(Map<String, dynamic> json) =>
    ActivitySummary(
      date: DateTime.parse(json['date'] as String),
      activeEnergyBurned: (json['activeEnergyBurned'] as List<dynamic>?)
              ?.map((e) => QuantitySample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      basalEnergyBurned: (json['basalEnergyBurned'] as List<dynamic>?)
              ?.map((e) => QuantitySample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => QuantitySample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      floorsClimbed: (json['floorsClimbed'] as List<dynamic>?)
              ?.map((e) => QuantitySample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      distanceWalkingRunning: (json['distanceWalkingRunning'] as List<dynamic>?)
              ?.map((e) => QuantitySample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      vo2Max: (json['vo2Max'] as List<dynamic>?)
              ?.map((e) => QuantitySample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

BodySummary _$BodySummaryFromJson(Map<String, dynamic> json) => BodySummary(
      bodyMass: (json['bodyMass'] as List<dynamic>?)
              ?.map((e) => QuantitySample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      bodyFatPercentage: (json['bodyFatPercentage'] as List<dynamic>?)
              ?.map((e) => QuantitySample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

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

SleepSummary _$SleepSummaryFromJson(Map<String, dynamic> json) => SleepSummary(
      id: json['id'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      sourceBundle: json['sourceBundle'] as String,
      heartRate: (json['heartRate'] as List<dynamic>?)
              ?.map((e) => QuantitySample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      restingHeartRate: (json['restingHeartRate'] as List<dynamic>?)
              ?.map((e) => QuantitySample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      heartRateVariability: (json['heartRateVariability'] as List<dynamic>?)
              ?.map((e) => QuantitySample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      oxygenSaturation: (json['oxygenSaturation'] as List<dynamic>?)
              ?.map((e) => QuantitySample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      respiratoryRate: (json['respiratoryRate'] as List<dynamic>?)
              ?.map((e) => QuantitySample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

WorkoutSummary _$WorkoutSummaryFromJson(Map<String, dynamic> json) =>
    WorkoutSummary(
      id: json['id'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      sourceBundle: json['sourceBundle'] as String,
      sport: json['sport'] as String,
      calories: (json['calories'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      heartRate: (json['heartRate'] as List<dynamic>?)
              ?.map((e) => QuantitySample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      respiratoryRate: (json['respiratoryRate'] as List<dynamic>?)
              ?.map((e) => QuantitySample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
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

ProfileSummary _$ProfileSummaryFromJson(Map<String, dynamic> json) =>
    ProfileSummary(
      biologicalSex:
          $enumDecodeNullable(_$BiologicalSexEnumMap, json['biologicalSex']) ??
              BiologicalSex.notSet,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      height: json['height'] as int?,
    );

const _$BiologicalSexEnumMap = {
  BiologicalSex.male: 'male',
  BiologicalSex.female: 'female',
  BiologicalSex.other: 'other',
  BiologicalSex.notSet: 'notSet',
};
