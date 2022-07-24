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
      userKey: json['user_key'] as String?,
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      weight: (json['weight'] as num?)?.toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
      source: Source.fromJson(json['source'] as Map<String, dynamic>),
    );
