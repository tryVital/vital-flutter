// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsLinkTokenValidRequest _$IsLinkTokenValidRequestFromJson(
        Map<String, dynamic> json) =>
    IsLinkTokenValidRequest(
      linkToken: json['token'] as String,
    );

Map<String, dynamic> _$IsLinkTokenValidRequestToJson(
        IsLinkTokenValidRequest instance) =>
    <String, dynamic>{
      'token': instance.linkToken,
    };

CreateLinkResponse _$CreateLinkResponseFromJson(Map<String, dynamic> json) =>
    CreateLinkResponse(
      linkToken: json['link_token'] as String,
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

LinkResponse _$LinkResponseFromJson(Map<String, dynamic> json) => LinkResponse(
      state: $enumDecode(_$LinkStateEnumMap, json['state']),
      redirectUrl: json['redirect_url'] as String?,
      errorType: json['error_type'] as String?,
      error: json['error'] as String?,
      providerMfa: json['provider_mfa'] == null
          ? null
          : LinkProviderMFA.fromJson(
              json['provider_mfa'] as Map<String, dynamic>),
    );

const _$LinkStateEnumMap = {
  LinkState.success: 'success',
  LinkState.error: 'error',
  LinkState.pendingProviderMfa: 'pending_provider_mfa',
};

LinkProviderMFA _$LinkProviderMFAFromJson(Map<String, dynamic> json) =>
    LinkProviderMFA(
      method: $enumDecode(_$LinkProviderMFAMethodEnumMap, json['method']),
      hint: json['hint'] as String,
    );

const _$LinkProviderMFAMethodEnumMap = {
  LinkProviderMFAMethod.sms: 'sms',
  LinkProviderMFAMethod.email: 'email',
};
