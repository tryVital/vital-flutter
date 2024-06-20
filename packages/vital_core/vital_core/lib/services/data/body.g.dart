// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BodyDataResponse _$BodyDataResponseFromJson(Map<String, dynamic> json) =>
    BodyDataResponse(
      body: (json['body'] as List<dynamic>?)
              ?.map((e) => BodyData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

BodyData _$BodyDataFromJson(Map<String, dynamic> json) => BodyData(
      userId: json['user_id'] as String?,
      id: json['id'] as String,
      calendarDate: json['calendar_date'] as String,
      weight: (json['weight'] as num?)?.toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
      source: Source.fromJson(json['source'] as Map<String, dynamic>),
    );
