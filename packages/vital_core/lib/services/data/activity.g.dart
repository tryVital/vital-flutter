// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivitiesResponse _$ActivitiesResponseFromJson(Map<String, dynamic> json) =>
    ActivitiesResponse(
      activity: (json['activity'] as List<dynamic>?)
              ?.map((e) => Activity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      userId: json['user_id'] as String?,
      userKey: json['user_key'] as String?,
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      caloriesTotal: (json['calories_total'] as num?)?.toDouble(),
      caloriesActive: (json['calories_active'] as num?)?.toDouble(),
      steps: (json['steps'] as num?)?.toDouble(),
      dailyMovement: (json['daily_movement'] as num?)?.toDouble(),
      low: (json['low'] as num?)?.toDouble(),
      medium: (json['medium'] as num?)?.toDouble(),
      high: (json['high'] as num?)?.toDouble(),
      source: Source.fromJson(json['source'] as Map<String, dynamic>),
    );
