// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      userId: json['user_id'] as String,
      id: json['id'] as String,
      height: (json['height'] as num?)?.toDouble(),
      source: Source.fromJson(json['source'] as Map<String, dynamic>),
    );
