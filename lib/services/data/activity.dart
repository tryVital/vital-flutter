import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'activity.g.dart';

@JsonSerializable()
class ActivitiesResponse {
  List<Activity> activity;

  ActivitiesResponse({
    this.activity = const [],
  });

  factory ActivitiesResponse.fromJson(Map<String, dynamic> json) => _$ActivitiesResponseFromJson(json);
}

@JsonSerializable()
class Activity {
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'user_key')
  String? userKey;
  String id;
  DateTime date;
  @JsonKey(name: 'calories_total')
  double? caloriesTotal;
  @JsonKey(name: 'calories_active')
  double? caloriesActive;
  double? steps;
  @JsonKey(name: 'daily_movement')
  double? dailyMovement;
  double? low;
  double? medium;
  double? high;
  Source source;

  Activity({
    this.userId,
    this.userKey,
    required this.id,
    required this.date,
    this.caloriesTotal,
    this.caloriesActive,
    this.steps,
    this.dailyMovement,
    this.low,
    this.medium,
    this.high,
    required this.source,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
}
