// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserConnection _$UserConnectionFromJson(Map<String, dynamic> json) =>
    UserConnection(
      name: json['name'] as String,
      slug: $enumDecode(_$ProviderSlugEnumMap, json['slug'],
          unknownValue: ProviderSlug.unrecognized),
      logo: json['logo'] as String?,
      status: $enumDecode(_$UserConnectionStatusEnumMap, json['status']),
      resourceAvailability:
          (json['resourceAvailability'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, ResourceAvailability.fromJson(e as Map<String, dynamic>)),
      ),
    );

const _$ProviderSlugEnumMap = {
  ProviderSlug.beurerBLE: 'beurer_ble',
  ProviderSlug.omronBLE: 'omron_ble',
  ProviderSlug.accuchekBLE: 'accuchek_ble',
  ProviderSlug.contourBLE: 'contour_ble',
  ProviderSlug.libreBLE: 'libre_ble',
  ProviderSlug.manual: 'manual',
  ProviderSlug.appleHealthKit: 'apple_health_kit',
  ProviderSlug.healthConnect: 'health_connect',
  ProviderSlug.iHealth: 'i_health',
  ProviderSlug.oura: 'oura',
  ProviderSlug.garmin: 'garmin',
  ProviderSlug.fitbit: 'fitbit',
  ProviderSlug.libre: 'libre',
  ProviderSlug.whoop: 'whoop',
  ProviderSlug.strava: 'strava',
  ProviderSlug.renpho: 'renpho',
  ProviderSlug.peloton: 'peloton',
  ProviderSlug.wahoo: 'wahoo',
  ProviderSlug.zwift: 'zwift',
  ProviderSlug.eightSleep: 'eight_sleep',
  ProviderSlug.withings: 'withings',
  ProviderSlug.googleFit: 'google_fit',
  ProviderSlug.hammerhead: 'hammerhead',
  ProviderSlug.dexcom: 'dexcom',
  ProviderSlug.myFitnessPal: 'my_fitness_pal',
  ProviderSlug.dexcomV3: 'dexcom_v3',
  ProviderSlug.cronometer: 'cronometer',
  ProviderSlug.polar: 'polar',
  ProviderSlug.omron: 'omron',
  ProviderSlug.kardia: 'kardia',
  ProviderSlug.abbottLibreview: 'abbott_libreview',
  ProviderSlug.unrecognized: 'unrecognized',
};

const _$UserConnectionStatusEnumMap = {
  UserConnectionStatus.connected: 'connected',
  UserConnectionStatus.error: 'error',
  UserConnectionStatus.paused: 'paused',
};

ResourceAvailability _$ResourceAvailabilityFromJson(
        Map<String, dynamic> json) =>
    ResourceAvailability(
      status: $enumDecode(_$ResourceAvailabilityStatusEnumMap, json['status']),
      scopeRequirements: json['scopeRequirements'] == null
          ? null
          : ScopeRequirementsGrants.fromJson(
              json['scopeRequirements'] as Map<String, dynamic>),
    );

const _$ResourceAvailabilityStatusEnumMap = {
  ResourceAvailabilityStatus.available: 'available',
  ResourceAvailabilityStatus.unavailable: 'unavailable',
};

ScopeRequirementsGrants _$ScopeRequirementsGrantsFromJson(
        Map<String, dynamic> json) =>
    ScopeRequirementsGrants(
      userGranted: ScopeRequirements.fromJson(
          json['userGranted'] as Map<String, dynamic>),
      userDenied: ScopeRequirements.fromJson(
          json['userDenied'] as Map<String, dynamic>),
    );

ScopeRequirements _$ScopeRequirementsFromJson(Map<String, dynamic> json) =>
    ScopeRequirements(
      required:
          (json['required'] as List<dynamic>).map((e) => e as String).toList(),
      optional:
          (json['optional'] as List<dynamic>).map((e) => e as String).toList(),
    );
