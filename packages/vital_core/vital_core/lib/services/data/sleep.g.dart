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
      timezoneOffset: (json['timezone_offset'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      awake: (json['awake'] as num?)?.toInt(),
      light: (json['light'] as num?)?.toInt(),
      rem: (json['rem'] as num?)?.toInt(),
      deep: (json['deep'] as num?)?.toInt(),
      score: (json['score'] as num?)?.toInt(),
      hrLowest: (json['hr_lowest'] as num?)?.toInt(),
      hrAverage: (json['hr_average'] as num?)?.toInt(),
      efficiency: (json['efficiency'] as num?)?.toDouble(),
      latency: (json['latency'] as num?)?.toInt(),
      temperatureDelta: (json['temperature_delta'] as num?)?.toDouble(),
      averageHrv: (json['average_hrv'] as num?)?.toDouble(),
      respiratoryRate: (json['respiratory_rate'] as num?)?.toDouble(),
      source: Source.fromJson(json['source'] as Map<String, dynamic>),
    );
