// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateLinkResponse _$CreateLinkResponseFromJson(Map<String, dynamic> json) =>
    CreateLinkResponse(
      linkToken: json['link_token'] as String?,
    );

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

EmailProviderResponse _$EmailProviderResponseFromJson(
        Map<String, dynamic> json) =>
    EmailProviderResponse(
      redirectUrl: json['redirect_url'] as String?,
      success: json['success'] as bool? ?? false,
    );
