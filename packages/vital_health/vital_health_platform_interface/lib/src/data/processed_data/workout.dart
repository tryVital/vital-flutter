import 'package:vital_core/samples.dart';

class Workout {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String? sourceBundle;
  final String? deviceModel;
  final String sport;
  final int caloriesInKiloJules;
  final int distanceInMeter;
  final List<QuantitySample> heartRate;
  final List<QuantitySample> respiratoryRate;

  Workout({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.sourceBundle,
    required this.deviceModel,
    required this.sport,
    required this.caloriesInKiloJules,
    required this.distanceInMeter,
    required this.heartRate,
    required this.respiratoryRate,
  });

  @override
  String toString() {
    return 'Workout{id: $id, startDate: $startDate, endDate: $endDate, sourceBundle: $sourceBundle, deviceModel: $deviceModel, sport: $sport, caloriesInKiloJules: $caloriesInKiloJules, distanceInMeter: $distanceInMeter, heartRate: $heartRate, respiratoryRate: $respiratoryRate}';
  }
}
