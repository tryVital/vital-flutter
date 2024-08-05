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
  final DateTime? dateOfBirth;
  final int? heightInCm;

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
  final List<LocalQuantitySample> bodyMass;
  final List<LocalQuantitySample> bodyFatPercentage;

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

class BloodPressureProcessedData extends ProcessedData {
  final List<LocalBloodPressureSample> timeSeries;

  BloodPressureProcessedData({
    required this.timeSeries,
  }) : super(HealthResource.bloodPressure);

  @override
  String toString() {
    return 'BloodPressureProcessedData{timeSeries: $timeSeries}';
  }
}

class TimeseriesProcessedData extends ProcessedData {
  final List<LocalQuantitySample> timeSeries;

  TimeseriesProcessedData({
    required this.timeSeries,
  }) : super(HealthResource.heartRate);

  @override
  String toString() {
    return 'TimeseriesProcessedData{timeSeries: $timeSeries}';
  }
}
