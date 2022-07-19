// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivitiesResponse _$ActivitiesResponseFromJson(Map<String, dynamic> json) => ActivitiesResponse(
      activity:
          (json['activity'] as List<dynamic>?)?.map((e) => Activity.fromJson(e as Map<String, dynamic>)).toList() ??
              const [],
    );

Map<String, dynamic> _$ActivitiesResponseToJson(ActivitiesResponse instance) => <String, dynamic>{
      'activity': instance.activity,
    };

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

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'user_id': instance.userId,
      'user_key': instance.userKey,
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'calories_total': instance.caloriesTotal,
      'calories_active': instance.caloriesActive,
      'steps': instance.steps,
      'daily_movement': instance.dailyMovement,
      'low': instance.low,
      'medium': instance.medium,
      'high': instance.high,
      'source': instance.source,
    };
