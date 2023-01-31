import 'package:vital_core/samples.dart';
import 'package:vital_health_platform_interface/src/data/processed_data/activity.dart';
import 'package:vital_health_platform_interface/src/data/processed_data/sleep.dart';
import 'package:vital_health_platform_interface/src/data/processed_data/workout.dart';
import 'package:vital_health_platform_interface/src/health_resource.dart';

abstract class ProcessedData {
  final HealthResource resource;

  ProcessedData(this.resource);
}

class ProfileProcessedData extends ProcessedData {
  final String biologicalSex;
  final DateTime dateOfBirth;
  final int heightInCm;

  ProfileProcessedData({
    required this.biologicalSex,
    required this.dateOfBirth,
    required this.heightInCm,
  }) : super(HealthResource.profile);

  @override
  String toString() {
    return 'ProfileProcessedData{biologicalSex: $biologicalSex, dateOfBirth: $dateOfBirth, heightInCm: $heightInCm}';
  }
}

  class BodyProcessedData extends ProcessedData {
  final List<QuantitySample> bodyMass;
  final List<QuantitySample> bodyFatPercentage;

  BodyProcessedData({
    required this.bodyMass,
    required this.bodyFatPercentage,
  }) : super(HealthResource.body);

  @override
  String toString() {
    return 'BodyProcessedData{bodyMass: $bodyMass, bodyFatPercentage: $bodyFatPercentage}';
  }
}

class ActivityProcessedData extends ProcessedData {
  final List<Activity> activities;

  ActivityProcessedData({
    required this.activities,
  }) : super(HealthResource.activity);

  @override
  String toString() {
    return 'ActivityProcessedData{activities: $activities}';
  }
}

class SleepProcessedData extends ProcessedData {
  final List<Sleep> sleeps;

  SleepProcessedData({
    required this.sleeps,
  }) : super(HealthResource.sleep);

  @override
  String toString() {
    return 'SleepProcessedData{sleepAnalysis: $sleeps}';
  }
}

class WorkoutProcessedData extends ProcessedData {
  final List<Workout> workouts;

  WorkoutProcessedData({
    required this.workouts,
  }) : super(HealthResource.workout);

  @override
  String toString() {
    return 'WorkoutProcessedData{workouts: $workouts}';
  }
}

class ActiveEnergyBurnedProcessedData extends ProcessedData {
  final List<Activity> activities;

  ActiveEnergyBurnedProcessedData({
    required this.activities,
  }) : super(HealthResource.activeEnergyBurned);

  @override
  String toString() {
    return 'ActiveEnergyBurnedProcessedData{activities: $activities}';
  }
}

class BasalEnergyBurnedProcessedData extends ProcessedData {
  final List<Activity> activities;

  BasalEnergyBurnedProcessedData({
    required this.activities,
  }) : super(HealthResource.basalEnergyBurned);

  @override
  String toString() {
    return 'BasalEnergyBurnedProcessedData{activities: $activities}';
  }
}

class GlucoseProcessedData extends ProcessedData {
  final List<QuantitySample> timeSeries;

  GlucoseProcessedData({
    required this.timeSeries,
  }) : super(HealthResource.glucose);

  @override
  String toString() {
    return 'GlucoseProcessedData{timeSeries: $timeSeries}';
  }
}

class BloodPressureProcessedData extends ProcessedData {
  final List<BloodPressureSample> timeSeries;

  BloodPressureProcessedData({
    required this.timeSeries,
  }) : super(HealthResource.bloodPressure);

  @override
  String toString() {
    return 'BloodPressureProcessedData{timeSeries: $timeSeries}';
  }
}

class HeartRateProcessedData extends ProcessedData {
  final List<QuantitySample> timeSeries;

  HeartRateProcessedData({
    required this.timeSeries,
  }) : super(HealthResource.heartRate);

  @override
  String toString() {
    return 'HeartRateProcessedData{timeSeries: $timeSeries}';
  }
}

class StepsProcessedData extends ProcessedData {
  final List<Activity> activities;

  StepsProcessedData({
    required this.activities,
  }) : super(HealthResource.steps);

  @override
  String toString() {
    return 'StepsProcessedData{activities: $activities}';
  }
}

class WaterProcessedData extends ProcessedData {
  final List<QuantitySample> timeSeries;

  WaterProcessedData({
    required this.timeSeries,
  }) : super(HealthResource.bloodPressure);

  @override
  String toString() {
    return 'WaterProcessedData{timeSeries: $timeSeries}';
  }
}

class CaffeineProcessedData extends ProcessedData {
  final List<QuantitySample> timeSeries;

  CaffeineProcessedData({
    required this.timeSeries,
  }) : super(HealthResource.caffeine);

  @override
  String toString() {
    return 'CaffeineProcessedData{timeSeries: $timeSeries}';
  }
}

class MindfulSessionProcessedData extends ProcessedData {
  final List<QuantitySample> timeSeries;

  MindfulSessionProcessedData({
    required this.timeSeries,
  }) : super(HealthResource.mindfulSession);

  @override
  String toString() {
    return 'MindfulSessionProcessedData{timeSeries: $timeSeries}';
  }
}
