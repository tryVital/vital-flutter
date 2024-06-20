import 'package:json_annotation/json_annotation.dart';
import 'package:vital_core/services/data/source.dart';

part 'body.g.dart';

@JsonSerializable(createToJson: false)
class BodyDataResponse {
  List<BodyData> body;

  BodyDataResponse({
    this.body = const [],
  });

  factory BodyDataResponse.fromJson(Map<String, dynamic> json) =>
      _$BodyDataResponseFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class BodyData {
  String? userId;
  String id;
  String calendarDate;
  double? weight;
  double? fat;
  Source source;

  BodyData({
    this.userId,
    required this.id,
    required this.calendarDate,
    this.weight,
    this.fat,
    required this.source,
  });

  factory BodyData.fromJson(Map<String, dynamic> json) =>
      _$BodyDataFromJson(json);
}
