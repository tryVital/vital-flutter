import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

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

@JsonSerializable(createToJson: false)
class BodyData {
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'user_key')
  String? userKey;
  String id;
  DateTime date;
  double? weight;
  double? fat;
  Source source;

  BodyData({
    this.userId,
    this.userKey,
    required this.id,
    required this.date,
    this.weight,
    this.fat,
    required this.source,
  });

  factory BodyData.fromJson(Map<String, dynamic> json) =>
      _$BodyDataFromJson(json);
}
