import 'package:vital_core/samples.dart';

class Sleep {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String? sourceBundle;
  final String? deviceModel;
  final List<QuantitySample> heartRate;
  final List<QuantitySample> restingHeartRate;
  final List<QuantitySample> heartRateVariability;
  final List<QuantitySample> oxygenSaturation;
  final List<QuantitySample> respiratoryRate;
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
  final List<QuantitySample> awakeSleepSamples;
  final List<QuantitySample> deepSleepSamples;
  final List<QuantitySample> lightSleepSamples;
  final List<QuantitySample> remSleepSamples;
  final List<QuantitySample> unknownSleepSamples;

  SleepStages({
    required this.awakeSleepSamples,
    required this.deepSleepSamples,
    required this.lightSleepSamples,
    required this.remSleepSamples,
    required this.unknownSleepSamples,
  });
}
