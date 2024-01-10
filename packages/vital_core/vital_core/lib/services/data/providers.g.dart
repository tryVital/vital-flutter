// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableProvider _$AvailableProviderFromJson(Map<String, dynamic> json) =>
    AvailableProvider(
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      logo: json['logo'] as String,
      authType:
          $enumDecodeNullable(_$ProviderAuthTypeEnumMap, json['auth_type']),
    );

const _$ProviderAuthTypeEnumMap = {
  ProviderAuthType.oauth: 'oauth',
  ProviderAuthType.teamOauth: 'team_oauth',
  ProviderAuthType.password: 'password',
  ProviderAuthType.email: 'email',
  ProviderAuthType.sdk: 'sdk',
  ProviderAuthType.none: '',
};
