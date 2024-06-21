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
      id: json['id'] as String,
      calendarDate: json['calendar_date'] as String,
      bedtimeStart: DateTime.parse(json['bedtime_start'] as String),
      bedtimeStop: DateTime.parse(json['bedtime_stop'] as String),
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
      source: Source.fromJson(json['source'] as Map<String, dynamic>),
    );
