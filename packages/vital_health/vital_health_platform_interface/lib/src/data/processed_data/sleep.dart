import 'package:vital_core/samples.dart';

class Sleep {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String? sourceBundle;
  final String? deviceModel;
  final List<LocalQuantitySample> heartRate;
  final List<LocalQuantitySample> restingHeartRate;
  final List<LocalQuantitySample> heartRateVariability;
  final List<LocalQuantitySample> oxygenSaturation;
  final List<LocalQuantitySample> respiratoryRate;
  final SleepStages sleepStages;

  Sleep({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.sourceBundle,
    required this.deviceModel,
    required this.heartRate,
    required this.restingHeartRate,
    required this.heartRateVariability,
    required this.oxygenSaturation,
    required this.respiratoryRate,
    required this.sleepStages,
  });

  @override
  String toString() {
    return 'Sleep{id: $id, startDate: $startDate, endDate: $endDate, sourceBundle: $sourceBundle, deviceModel: $deviceModel, heartRate: $heartRate, restingHeartRate: $restingHeartRate, heartRateVariability: $heartRateVariability, oxygenSaturation: $oxygenSaturation, respiratoryRate: $respiratoryRate, sleepStages: $sleepStages}';
  }
}

class SleepStages {
  final List<LocalQuantitySample> awakeSleepSamples;
  final List<LocalQuantitySample> deepSleepSamples;
  final List<LocalQuantitySample> lightSleepSamples;
  final List<LocalQuantitySample> remSleepSamples;
  final List<LocalQuantitySample> unknownSleepSamples;
  final List<LocalQuantitySample> inBedSleepSamples;
  final List<LocalQuantitySample> unspecifiedSleepSamples;

  SleepStages({
    required this.awakeSleepSamples,
    required this.deepSleepSamples,
    required this.lightSleepSamples,
    required this.remSleepSamples,
    required this.unknownSleepSamples,
    required this.inBedSleepSamples,
    required this.unspecifiedSleepSamples,
  });

  @override
  String toString() {
    return 'SleepStages{awakeSleepSamples: $awakeSleepSamples, deepSleepSamples: $deepSleepSamples, lightSleepSamples: $lightSleepSamples, remSleepSamples: $remSleepSamples, unknownSleepSamples: $unknownSleepSamples, inBedSleepSamples: $inBedSleepSamples}';
  }
}
