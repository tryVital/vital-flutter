import 'package:json_annotation/json_annotation.dart';

part 'vitals.g.dart';

@JsonSerializable(createToJson: false)
class Measurement {
  int id;
  DateTime timestamp;
  double? value;
  String? type;
  String? unit;

  Measurement({
    required this.id,
    required this.timestamp,
    this.value,
    this.type,
    this.unit,
  });

  factory Measurement.fromJson(Map<String, dynamic> json) =>
      _$MeasurementFromJson(json);
}

@JsonSerializable(createToJson: false)
class BloodPressureMeasurement {
  int? id;
  DateTime timestamp;
  double systolic;
  double diastolic;
  String? type;
  String? unit;

  BloodPressureMeasurement({
    required this.id,
    required this.timestamp,
    required this.systolic,
    required this.diastolic,
    this.type,
    this.unit,
  });

  factory BloodPressureMeasurement.fromJson(Map<String, dynamic> json) =>
      _$BloodPressureMeasurementFromJson(json);
}

enum CholesterolType {
  ldl,
  total,
  triglycerides,
  hdl,
}
