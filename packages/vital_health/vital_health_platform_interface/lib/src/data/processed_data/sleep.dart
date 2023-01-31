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
  });
}
