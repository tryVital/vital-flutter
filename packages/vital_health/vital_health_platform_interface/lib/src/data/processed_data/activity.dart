import 'package:vital_core/samples.dart';

class Activity {
  final List<QuantitySample> activeEnergyBurned;
  final List<QuantitySample> basalEnergyBurned;
  final List<QuantitySample> steps;
  final List<QuantitySample> floorsClimbed;
  final List<QuantitySample> distanceWalkingRunning;
  final List<QuantitySample> vo2Max;

  Activity({
    required this.activeEnergyBurned,
    required this.basalEnergyBurned,
    required this.steps,
    required this.floorsClimbed,
    required this.distanceWalkingRunning,
    required this.vo2Max,
  });

  @override
  String toString() {
    return 'Activity{activeEnergyBurned: $activeEnergyBurned, basalEnergyBurned: $basalEnergyBurned, steps: $steps, floorsClimbed: $floorsClimbed, distanceWalkingRunning: $distanceWalkingRunning, vo2Max: $vo2Max}';
  }
}
