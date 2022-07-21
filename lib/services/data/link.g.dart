// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateLinkResponse _$CreateLinkResponseFromJson(Map<String, dynamic> json) =>
    CreateLinkResponse(
      linkToken: json['link_token'] as String?,
    );

Map<String, dynamic> _$CreateLinkResponseToJson(CreateLinkResponse instance) =>
    <String, dynamic>{
      'link_token': instance.linkToken,
    };

OauthLinkResponse _$OauthLinkResponseFromJson(Map<String, dynamic> json) =>
    OauthLinkResponse(
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      logo: json['logo'] as String?,
      group: json['group'] as String?,
      oauthUrl: json['oauth_url'] as String?,
      authType: json['auth_type'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      id: json['id'] as int? ?? -1,
    );

Map<String, dynamic> _$OauthLinkResponseToJson(OauthLinkResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'logo': instance.logo,
      'group': instance.group,
      'oauth_url': instance.oauthUrl,
      'auth_type': instance.authType,
      'is_active': instance.isActive,
      'id': instance.id,
    };
