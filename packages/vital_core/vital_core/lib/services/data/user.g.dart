// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: json['user_id'] as String,
      teamId: json['team_id'] as String,
      clientUserId: json['client_user_id'] as String,
      createdOn: DateTime.parse(json['created_on'] as String),
      fallbackTimeZone: json['fallback_time_zone'] == null
          ? null
          : UserFallbackTimeZone.fromJson(
              json['fallback_time_zone'] as Map<String, dynamic>),
    );

UserFallbackTimeZone _$UserFallbackTimeZoneFromJson(
        Map<String, dynamic> json) =>
    UserFallbackTimeZone(
      json['id'] as String,
      json['source_slug'] as String,
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

RefreshResponse _$RefreshResponseFromJson(Map<String, dynamic> json) =>
    RefreshResponse(
      success: json['success'] as bool? ?? false,
      error: json['error'] as String?,
      userId: json['user_id'] as String?,
      refreshedSources: (json['refreshed_sources'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      failedSources: (json['failed_sources'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

DeregisterProviderResponse _$DeregisterProviderResponseFromJson(
        Map<String, dynamic> json) =>
    DeregisterProviderResponse(
      success: json['success'] as bool? ?? false,
    );
