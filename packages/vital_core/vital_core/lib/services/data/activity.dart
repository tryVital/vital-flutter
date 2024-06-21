import 'package:json_annotation/json_annotation.dart';
import 'package:vital_core/services/data/source.dart';

part 'activity.g.dart';

@JsonSerializable(createToJson: false)
class ActivitiesResponse {
  List<Activity> activity;

  ActivitiesResponse({
    this.activity = const [],
  });

  factory ActivitiesResponse.fromJson(Map<String, dynamic> json) =>
      _$ActivitiesResponseFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Activity {
  String? userId;
  String id;
  String calendarDate;
  double? caloriesTotal;
  double? caloriesActive;
  double? steps;
  double? distance;
  double? low;
  double? medium;
  double? high;
  Source source;

  Activity({
    this.userId,
    required this.id,
    required this.calendarDate,
    this.caloriesTotal,
    this.caloriesActive,
    this.steps,
    this.low,
    this.medium,
    this.high,
    required this.source,
  });

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}
