import 'package:vital_core/samples.dart';

class Activity {
  final List<LocalQuantitySample> activeEnergyBurned;
  final List<LocalQuantitySample> basalEnergyBurned;
  final List<LocalQuantitySample> steps;
  final List<LocalQuantitySample> floorsClimbed;
  final List<LocalQuantitySample> distanceWalkingRunning;
  final List<LocalQuantitySample> vo2Max;

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
