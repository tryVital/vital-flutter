// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Source _$SourceFromJson(Map<String, dynamic> json) => Source(
      provider: $enumDecode(_$ProviderSlugEnumMap, json['provider'],
          unknownValue: ProviderSlug.unrecognized),
      type: $enumDecode(_$SourceTypeEnumMap, json['type'],
          unknownValue: SourceType.unrecognized),
      appId: json['appId'] as String?,
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

const _$SourceTypeEnumMap = {
  SourceType.phone: 'phone',
  SourceType.watch: 'watch',
  SourceType.app: 'app',
  SourceType.ring: 'ring',
  SourceType.scale: 'scale',
  SourceType.multipleSources: 'multiple_sources',
  SourceType.chestStrap: 'chest_strap',
  SourceType.manualScan: 'manual_scan',
  SourceType.automatic: 'automatic',
  SourceType.cuff: 'cuff',
  SourceType.fingerprick: 'fingerprick',
  SourceType.unknown: 'unknown',
  SourceType.unrecognized: 'unrecognized',
};
