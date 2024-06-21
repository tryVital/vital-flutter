import 'package:json_annotation/json_annotation.dart';
import 'package:vital_core/services/data/source.dart';

part 'timeseries.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class ScalarSample {
  DateTime timestamp;
  double value;
  String? type;
  String unit;
  int? timezoneOffset;

  ScalarSample(
      {required this.timestamp,
      required this.value,
      this.type,
      required this.unit,
      this.timezoneOffset});

  factory ScalarSample.fromJson(Map<String, dynamic> json) =>
      _$ScalarSampleFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class IntervalSample {
  DateTime start;
  DateTime end;
  double value;
  String? type;
  String unit;
  int? timezoneOffset;

  IntervalSample({
    required this.start,
    required this.end,
    required this.value,
    this.type,
    required this.unit,
    this.timezoneOffset,
  });

  factory IntervalSample.fromJson(Map<String, dynamic> json) =>
      _$IntervalSampleFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class BloodPressureSample {
  DateTime timestamp;
  double systolic;
  double diastolic;
  String? type;
  String unit;
  int? timezoneOffset;

  BloodPressureSample({
    required this.timestamp,
    required this.systolic,
    required this.diastolic,
    this.type,
    required this.unit,
    this.timezoneOffset,
  });

  factory BloodPressureSample.fromJson(Map<String, dynamic> json) =>
      _$BloodPressureSampleFromJson(json);
}

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.snake)
enum ScalarTimeseriesResource {
  bloodOxygen,
  glucose,
  heartrate,
  heartrateVariability,
  respiratoryRate;

  String toJson() {
    return _$ScalarTimeseriesResourceEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.snake)
enum IntervalTimeseriesResource {
  hypnogram,
  steps;

  String toJson() {
    return _$IntervalTimeseriesResourceEnumMap[this]!;
  }
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class GroupedScalarTimeseries {
  List<ScalarSample> data;
  Source source;

  GroupedScalarTimeseries({
    required this.data,
    required this.source,
  });

  factory GroupedScalarTimeseries.fromJson(Map<String, dynamic> json) =>
      _$GroupedScalarTimeseriesFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class GroupedIntervalTimeseries {
  List<IntervalSample> data;
  Source source;

  GroupedIntervalTimeseries({
    required this.data,
    required this.source,
  });

  factory GroupedIntervalTimeseries.fromJson(Map<String, dynamic> json) =>
      _$GroupedIntervalTimeseriesFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class GroupedBloodPressureTimeseries {
  List<IntervalSample> data;
  Source source;

  GroupedBloodPressureTimeseries({
    required this.data,
    required this.source,
  });

  factory GroupedBloodPressureTimeseries.fromJson(Map<String, dynamic> json) =>
      _$GroupedBloodPressureTimeseriesFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class GroupedScalarTimeseriesResponse {
  Map<String, List<GroupedScalarTimeseries>> groups;
  String? nextCursor;

  GroupedScalarTimeseriesResponse({required this.groups, this.nextCursor});

  factory GroupedScalarTimeseriesResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupedScalarTimeseriesResponseFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class GroupedIntervalTimeseriesResponse {
  Map<String, List<GroupedIntervalTimeseries>> groups;
  String? nextCursor;

  GroupedIntervalTimeseriesResponse({required this.groups, this.nextCursor});

  factory GroupedIntervalTimeseriesResponse.fromJson(
          Map<String, dynamic> json) =>
      _$GroupedIntervalTimeseriesResponseFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class GroupedBloodPressureTimeseriesResponse {
  Map<String, List<GroupedBloodPressureTimeseries>> groups;
  String? nextCursor;

  GroupedBloodPressureTimeseriesResponse(
      {required this.groups, this.nextCursor});

  factory GroupedBloodPressureTimeseriesResponse.fromJson(
          Map<String, dynamic> json) =>
      _$GroupedBloodPressureTimeseriesResponseFromJson(json);
}
