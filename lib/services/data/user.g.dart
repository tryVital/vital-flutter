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

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'user_id': instance.userId,
      'user_key': instance.userKey,
      'team_id': instance.teamId,
      'client_user_id': instance.clientUserId,
      'created_on': instance.createdOn?.toIso8601String(),
      'connected_sources': instance.connectedSources,
    };

ConnectedSource _$ConnectedSourceFromJson(Map<String, dynamic> json) =>
    ConnectedSource(
      source: json['source'] == null
          ? null
          : Source.fromJson(json['source'] as Map<String, dynamic>),
      createdOn: json['created_on'] == null
          ? null
          : DateTime.parse(json['created_on'] as String),
    );

Map<String, dynamic> _$ConnectedSourceToJson(ConnectedSource instance) =>
    <String, dynamic>{
      'source': instance.source,
      'created_on': instance.createdOn?.toIso8601String(),
    };

Source _$SourceFromJson(Map<String, dynamic> json) => Source(
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      logo: json['logo'] as String?,
    );

Map<String, dynamic> _$SourceToJson(Source instance) => <String, dynamic>{
      'name': instance.name,
      'slug': instance.slug,
      'logo': instance.logo,
    };

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

Map<String, dynamic> _$RefreshResponseToJson(RefreshResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'user_id': instance.userId,
      'error': instance.error,
      'refreshed_sources': instance.refreshedSources,
      'failed_sources': instance.failedSources,
    };

ProvidersResponse _$ProvidersResponseFromJson(Map<String, dynamic> json) =>
    ProvidersResponse(
      providers: (json['providers'] as List<dynamic>?)
              ?.map((e) => Source.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ProvidersResponseToJson(ProvidersResponse instance) =>
    <String, dynamic>{
      'providers': instance.providers,
    };

CreateUserResponse _$CreateUserResponseFromJson(Map<String, dynamic> json) =>
    CreateUserResponse(
      userId: json['user_id'] as String?,
      userKey: json['user_key'] as String?,
      clientUserId: json['client_user_id'] as String?,
    );

Map<String, dynamic> _$CreateUserResponseToJson(CreateUserResponse instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'user_key': instance.userKey,
      'client_user_id': instance.clientUserId,
    };

DeleteUserResponse _$DeleteUserResponseFromJson(Map<String, dynamic> json) =>
    DeleteUserResponse(
      success: json['success'] as bool? ?? false,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$DeleteUserResponseToJson(DeleteUserResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
    };

DeregisterProviderResponse _$DeregisterProviderResponseFromJson(
        Map<String, dynamic> json) =>
    DeregisterProviderResponse(
      success: json['success'] as bool? ?? false,
    );

Map<String, dynamic> _$DeregisterProviderResponseToJson(
        DeregisterProviderResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
    };
