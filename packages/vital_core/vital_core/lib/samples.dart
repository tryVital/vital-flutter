import 'package:json_annotation/json_annotation.dart';

part 'samples.g.dart';

@JsonSerializable(createToJson: false)
class LocalQuantitySample {
  final String? id;
  final double value;
  final DateTime startDate;
  final DateTime endDate;
  final String? sourceBundle;
  final String? type;
  final String unit;

  LocalQuantitySample({
    this.id,
    required this.value,
    required this.startDate,
    required this.endDate,
    this.sourceBundle,
    this.type,
    required this.unit,
  });

  factory LocalQuantitySample.fromJson(Map<String, dynamic> json) =>
      _$LocalQuantitySampleFromJson(json);

  @override
  String toString() {
    return 'LocalQuantitySample{id: $id, value: $value, startDate: $startDate, endDate: $endDate, sourceBundle: $sourceBundle, type: $type, unit: $unit}';
  }
}

@JsonSerializable(createToJson: false)
class LocalBloodPressureSample {
  final LocalQuantitySample systolic;
  final LocalQuantitySample diastolic;
  final LocalQuantitySample? pulse;

  LocalBloodPressureSample({
    required this.systolic,
    required this.diastolic,
    this.pulse,
  });

  factory LocalBloodPressureSample.fromJson(Map<String, dynamic> json) =>
      _$LocalBloodPressureSampleFromJson(json);

  @override
  String toString() {
    return 'LocalBloodPressureSample{systolic: $systolic, diastolic: $diastolic, pulse: $pulse}';
  }
}
