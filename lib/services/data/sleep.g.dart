// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SleepResponse _$SleepResponseFromJson(Map<String, dynamic> json) =>
    SleepResponse(
      sleep: (json['sleep'] as List<dynamic>?)
              ?.map((e) => SleepData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

SleepData _$SleepDataFromJson(Map<String, dynamic> json) => SleepData(
      userId: json['user_id'] as String?,
      userKey: json['user_key'] as String?,
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      bedtimeStart: json['bedtime_start'] == null
          ? null
          : DateTime.parse(json['bedtime_start'] as String),
      bedtimeStop: json['bedtime_stop'] == null
          ? null
          : DateTime.parse(json['bedtime_stop'] as String),
      timezoneOffset: json['timezone_offset'] as int?,
      duration: json['duration'] as int?,
      total: json['total'] as int?,
      awake: json['awake'] as int?,
      light: json['light'] as int?,
      rem: json['rem'] as int?,
      deep: json['deep'] as int?,
      score: json['score'] as int?,
      hrLowest: json['hr_lowest'] as int?,
      hrAverage: json['hr_average'] as int?,
      efficiency: (json['efficiency'] as num?)?.toDouble(),
      latency: json['latency'] as int?,
      temperatureDelta: (json['temperature_delta'] as num?)?.toDouble(),
      averageHrv: (json['average_hrv'] as num?)?.toDouble(),
      respiratoryRate: (json['respiratory_rate'] as num?)?.toDouble(),
      source: json['source'] == null
          ? null
          : Source.fromJson(json['source'] as Map<String, dynamic>),
      sleepStream: json['sleep_stream'] == null
          ? null
          : SleepStreamResponse.fromJson(
              json['sleep_stream'] as Map<String, dynamic>),
    );

SleepStreamResponse _$SleepStreamResponseFromJson(Map<String, dynamic> json) =>
    SleepStreamResponse(
      hrv: (json['hrv'] as List<dynamic>?)
              ?.map((e) => Measurement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      heartrate: (json['heartrate'] as List<dynamic>?)
              ?.map((e) => Measurement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      hypnogram: (json['hypnogram'] as List<dynamic>?)
              ?.map((e) => Measurement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      respiratoryRate: (json['respiratory_rate'] as List<dynamic>?)
              ?.map((e) => Measurement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
