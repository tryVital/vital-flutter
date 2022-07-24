// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: json['user_id'] as String?,
      userKey: json['user_key'] as String?,
      teamId: json['team_id'] as String?,
      clientUserId: json['client_user_id'] as String?,
      createdOn: json['created_on'] == null
          ? null
          : DateTime.parse(json['created_on'] as String),
      connectedSources: (json['connected_sources'] as List<dynamic>?)
              ?.map((e) => ConnectedSource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

ConnectedSource _$ConnectedSourceFromJson(Map<String, dynamic> json) =>
    ConnectedSource(
      source: json['source'] == null
          ? null
          : Source.fromJson(json['source'] as Map<String, dynamic>),
      createdOn: json['created_on'] == null
          ? null
          : DateTime.parse(json['created_on'] as String),
    );

Source _$SourceFromJson(Map<String, dynamic> json) => Source(
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      logo: json['logo'] as String?,
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

ProvidersResponse _$ProvidersResponseFromJson(Map<String, dynamic> json) =>
    ProvidersResponse(
      providers: (json['providers'] as List<dynamic>?)
              ?.map((e) => Source.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

CreateUserResponse _$CreateUserResponseFromJson(Map<String, dynamic> json) =>
    CreateUserResponse(
      userId: json['user_id'] as String?,
      userKey: json['user_key'] as String?,
      clientUserId: json['client_user_id'] as String?,
    );

DeleteUserResponse _$DeleteUserResponseFromJson(Map<String, dynamic> json) =>
    DeleteUserResponse(
      success: json['success'] as bool? ?? false,
      error: json['error'] as String?,
    );

DeregisterProviderResponse _$DeregisterProviderResponseFromJson(
        Map<String, dynamic> json) =>
    DeregisterProviderResponse(
      success: json['success'] as bool? ?? false,
    );
