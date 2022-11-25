import 'package:json_annotation/json_annotation.dart';

part 'samples.g.dart';

@JsonSerializable(createToJson: false)
class QuantitySample {
  final String? id;
  final double value;
  final DateTime startDate;
  final DateTime endDate;
  final String? sourceBundle;
  final String? type;
  final String unit;

  QuantitySample({
    this.id,
    required this.value,
    required this.startDate,
    required this.endDate,
    this.sourceBundle,
    this.type,
    required this.unit,
  });

  factory QuantitySample.fromJson(Map<String, dynamic> json) =>
      _$QuantitySampleFromJson(json);
}

@JsonSerializable(createToJson: false)
class BloodPressureSample {
  final QuantitySample systolic;
  final QuantitySample diastolic;
  final QuantitySample? pulse;

  BloodPressureSample({
    required this.systolic,
    required this.diastolic,
    this.pulse,
  });

  factory BloodPressureSample.fromJson(Map<String, dynamic> json) =>
      _$BloodPressureSampleFromJson(json);
}
