import 'package:json_annotation/json_annotation.dart';
import 'package:vital_core/services/data/vitals.dart';
import 'user.dart';

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

@JsonSerializable(createToJson: false)
class SleepData {
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'user_key')
  String? userKey;
  String id;
  DateTime date;
  @JsonKey(name: 'bedtime_start')
  DateTime? bedtimeStart;
  @JsonKey(name: 'bedtime_stop')
  DateTime? bedtimeStop;
  @JsonKey(name: 'timezone_offset')
  int? timezoneOffset;
  int? duration;
  int? total;
  int? awake;
  int? light;
  int? rem;
  int? deep;
  int? score;
  @JsonKey(name: 'hr_lowest')
  int? hrLowest;
  @JsonKey(name: 'hr_average')
  int? hrAverage;
  double? efficiency;
  int? latency;
  @JsonKey(name: 'temperature_delta')
  double? temperatureDelta;
  @JsonKey(name: 'average_hrv')
  double? averageHrv;
  @JsonKey(name: 'respiratory_rate')
  double? respiratoryRate;
  Source? source;
  @JsonKey(name: 'sleep_stream')
  SleepStreamResponse? sleepStream;

  SleepData({
    this.userId,
    this.userKey,
    required this.id,
    required this.date,
    this.bedtimeStart,
    this.bedtimeStop,
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
    this.source,
    this.sleepStream,
  });

  factory SleepData.fromJson(Map<String, dynamic> json) =>
      _$SleepDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class SleepStreamResponse {
  List<Measurement> hrv;
  List<Measurement> heartrate;
  List<Measurement> hypnogram;
  @JsonKey(name: 'respiratory_rate')
  List<Measurement> respiratoryRate;

  SleepStreamResponse({
    this.hrv = const [],
    this.heartrate = const [],
    this.hypnogram = const [],
    this.respiratoryRate = const [],
  });

  factory SleepStreamResponse.fromJson(Map<String, dynamic> json) =>
      _$SleepStreamResponseFromJson(json);
}
