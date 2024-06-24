import 'package:json_annotation/json_annotation.dart';
import 'package:vital_core/services/data/source.dart';

part 'sleep.g.dart';

@JsonSerializable(createToJson: false)
class SleepResponse {
  List<SleepData> sleep;

  SleepResponse({
    this.sleep = const [],
  });

  factory SleepResponse.fromJson(Map<String, dynamic> json) =>
      _$SleepResponseFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class SleepData {
  String? userId;
  String id;
  String calendarDate;
  DateTime bedtimeStart;
  DateTime bedtimeStop;
  int? timezoneOffset;
  int? duration;
  int? total;
  int? awake;
  int? light;
  int? rem;
  int? deep;
  int? score;
  int? hrLowest;
  int? hrAverage;
  double? efficiency;
  int? latency;
  double? temperatureDelta;
  double? averageHrv;
  double? respiratoryRate;
  Source source;

  SleepData({
    this.userId,
    required this.id,
    required this.calendarDate,
    required this.bedtimeStart,
    required this.bedtimeStop,
    this.timezoneOffset,
    this.duration,
    this.total,
    this.awake,
    this.light,
    this.rem,
    this.deep,
    this.score,
    this.hrLowest,
    this.hrAverage,
    this.efficiency,
    this.latency,
    this.temperatureDelta,
    this.averageHrv,
    this.respiratoryRate,
    required this.source,
  });

  factory SleepData.fromJson(Map<String, dynamic> json) =>
      _$SleepDataFromJson(json);
}
