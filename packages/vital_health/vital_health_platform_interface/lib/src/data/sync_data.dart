import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:vital_core/samples.dart';
import 'package:vital_health_platform_interface/vital_health_platform_interface.dart';

part 'sync_data.g.dart';

enum SyncStatusType {
  failedSyncing,
  successSyncing,
  nothingToSync,
  syncing,
  syncingCompleted,
  unknown,
}

abstract class SyncStatus {
  final SyncStatusType status;

  SyncStatus(this.status);
}

class SyncStatusFailed extends SyncStatus {
  final HealthResource resource;
  final String? error;

  SyncStatusFailed(this.resource, this.error)
      : super(SyncStatusType.failedSyncing);
}

class SyncStatusSuccessSyncing<T> extends SyncStatus {
  final HealthResource resource;
  final T data;

  SyncStatusSuccessSyncing(this.resource, this.data)
      : super(SyncStatusType.successSyncing);
}

class SyncStatusNothingToSync extends SyncStatus {
  final HealthResource resource;

  SyncStatusNothingToSync(this.resource) : super(SyncStatusType.nothingToSync);
}

class SyncStatusSyncing extends SyncStatus {
  final HealthResource resource;

  SyncStatusSyncing(this.resource) : super(SyncStatusType.syncing);
}

class SyncStatusCompleted extends SyncStatus {
  SyncStatusCompleted() : super(SyncStatusType.syncingCompleted);
}

class SyncStatusUnknown extends SyncStatus {
  SyncStatusUnknown() : super(SyncStatusType.unknown);
}

enum PostResourceDataType {
  activity,
  body,
  profile,
  sleep,
  workout,
  glucose,
  bloodPressure,
  hearthRate,
  unknown,
}

Object? fromArgument(HealthResource resource, String argument) {
  switch (resource) {
    case HealthResource.activity:
      return (jsonDecode(argument) as List)
          .map((e) => ActivitySummary.fromJson(e))
          .toList();
    case HealthResource.profile:
      return ProfileSummary.fromJson(jsonDecode(argument));
    case HealthResource.body:
      return BodySummary.fromJson(jsonDecode(argument));
    case HealthResource.sleep:
      return (jsonDecode(argument) as List)
          .map((e) => SleepSummary.fromJson(e))
          .toList();
    case HealthResource.workout:
      return (jsonDecode(argument) as List)
          .map((e) => WorkoutSummary.fromJson(e))
          .toList();
    case HealthResource.glucose:
      return (jsonDecode(argument) as List)
          .map((e) => QuantitySample.fromJson(e))
          .toList();
    case HealthResource.bloodPressure:
      return (jsonDecode(argument) as List)
          .map((e) => BloodPressureSample.fromJson(e))
          .toList();
    case HealthResource.heartRate:
      return (jsonDecode(argument) as List)
          .map((e) => QuantitySample.fromJson(e))
          .toList();
    case HealthResource.water:
      return (jsonDecode(argument) as List)
          .map((e) => QuantitySample.fromJson(e))
          .toList();
    case HealthResource.caffeine:
      return (jsonDecode(argument) as List)
          .map((e) => QuantitySample.fromJson(e))
          .toList();
    default:
      return null;
  }
}

@JsonSerializable(createToJson: false)
class ActivitySummary {
  final DateTime date;
  final List<QuantitySample> activeEnergyBurned;
  final List<QuantitySample> basalEnergyBurned;
  final List<QuantitySample> steps;
  final List<QuantitySample> floorsClimbed;
  final List<QuantitySample> distanceWalkingRunning;
  final List<QuantitySample> vo2Max;

  ActivitySummary({
    required this.date,
    this.activeEnergyBurned = const [],
    this.basalEnergyBurned = const [],
    this.steps = const [],
    this.floorsClimbed = const [],
    this.distanceWalkingRunning = const [],
    this.vo2Max = const [],
  });

  factory ActivitySummary.fromJson(Map<String, dynamic> json) =>
      _$ActivitySummaryFromJson(json);
}

@JsonSerializable(createToJson: false)
class BodySummary {
  final List<QuantitySample> bodyMass;
  final List<QuantitySample> bodyFatPercentage;

  BodySummary({this.bodyMass = const [], this.bodyFatPercentage = const []});

  factory BodySummary.fromJson(Map<String, dynamic> json) =>
      _$BodySummaryFromJson(json);
}

@JsonSerializable(createToJson: false)
class SleepSummary {
  final String? id;
  final DateTime startDate;
  final DateTime endDate;
  final String sourceBundle;

  final List<QuantitySample> heartRate;
  final List<QuantitySample> restingHeartRate;
  final List<QuantitySample> heartRateVariability;
  final List<QuantitySample> oxygenSaturation;
  final List<QuantitySample> respiratoryRate;

  SleepSummary({
    this.id,
    required this.startDate,
    required this.endDate,
    required this.sourceBundle,
    this.heartRate = const [],
    this.restingHeartRate = const [],
    this.heartRateVariability = const [],
    this.oxygenSaturation = const [],
    this.respiratoryRate = const [],
  });

  factory SleepSummary.fromJson(Map<String, dynamic> json) =>
      _$SleepSummaryFromJson(json);
}

@JsonSerializable(createToJson: false)
class WorkoutSummary {
  final String? id;
  final DateTime startDate;
  final DateTime endDate;
  final String sourceBundle;
  final String sport;
  final double calories;
  final double distance;

  final List<QuantitySample> heartRate;
  final List<QuantitySample> respiratoryRate;

  WorkoutSummary({
    this.id,
    required this.startDate,
    required this.endDate,
    required this.sourceBundle,
    required this.sport,
    required this.calories,
    required this.distance,
    this.heartRate = const [],
    this.respiratoryRate = const [],
  });

  factory WorkoutSummary.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSummaryFromJson(json);
}

enum BiologicalSex {
  male,
  female,
  other,
  notSet,
}

@JsonSerializable(createToJson: false)
class ProfileSummary {
  final BiologicalSex biologicalSex;
  final DateTime? dateOfBirth;
  final int? height;

  ProfileSummary({
    this.biologicalSex = BiologicalSex.notSet,
    this.dateOfBirth,
    this.height,
  });

  factory ProfileSummary.fromJson(Map<String, dynamic> json) =>
      _$ProfileSummaryFromJson(json);
}
