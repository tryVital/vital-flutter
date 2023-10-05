import 'package:json_annotation/json_annotation.dart';

part 'provider.g.dart';

// NOTE: Provider name clashes with popular package
// https://pub.dev/packages/provider
// when the package is imported without namespacing

@JsonSerializable(createToJson: false)
class VitalProvider {
  String name;
  String slug;
  String? logo;

  VitalProvider({
    required this.name,
    required this.slug,
    this.logo,
  });

  factory VitalProvider.fromJson(Map<String, dynamic> json) =>
      _$VitalProviderFromJson(json);

  ProviderSlug? resolveSlug() {
    try {
      return ProviderSlug.values
          .firstWhere((slug) => slug.toString() == this.slug);
    } catch (err) {
      assert(err is StateError);
      return null;
    }
  }
}

enum ManualProviderSlug {
  beurerBLE,
  omronBLE,
  accuchekBLE,
  contourBLE,
  libreBLE,
  manual,
  appleHealthKit,
  healthConnect;

  @override
  String toString() {
    switch (this) {
      case beurerBLE:
        return "beurer_ble";
      case omronBLE:
        return "omron_ble";
      case accuchekBLE:
        return "accuchek_ble";
      case contourBLE:
        return "contour_ble";
      case libreBLE:
        return "freestyle_libre_ble";
      case manual:
        return "manual";
      case appleHealthKit:
        return "apple_health_kit";
      case healthConnect:
        return "health_connect";
    }
  }
}

enum ProviderSlug {
  beurerBLE,
  omronBLE,
  accuchekBLE,
  contourBLE,
  libreBLE,
  manual,
  appleHealthKit,
  healthConnect,

  iHealth,
  oura,
  garmin,
  fitbit,
  libre,
  whoop,
  strava,
  renpho,
  peloton,
  wahoo,
  zwift,
  eightSleep,
  withings,
  googleFit,
  hammerhead,
  dexcom,
  myFitnessPal,
  dexcomV3,
  cronometer,
  polar,
  omron;

  static ProviderSlug? fromString(String rawValue) {
    try {
      return ProviderSlug.values
          .firstWhere((element) => element.toString() == rawValue);
    } catch (err) {
      assert(err is StateError);
      return null;
    }
  }

  @override
  String toString() {
    switch (this) {
      case beurerBLE:
        return "beurer_ble";
      case omronBLE:
        return "omron_ble";
      case accuchekBLE:
        return "accuchek_ble";
      case contourBLE:
        return "contour_ble";
      case libreBLE:
        return "freestyle_libre_ble";
      case manual:
        return "manual";
      case appleHealthKit:
        return "apple_health_kit";
      case healthConnect:
        return "health_connect";
      case iHealth:
        return "ihealth";
      case oura:
        return "oura";
      case garmin:
        return "garmin";
      case fitbit:
        return "fitbit";
      case libre:
        return "freestyle_libre";
      case whoop:
        return "whoop";
      case strava:
        return "strava";
      case renpho:
        return "renpho";
      case peloton:
        return "peloton";
      case wahoo:
        return "wahoo";
      case zwift:
        return "zwift";
      case eightSleep:
        return "eight_sleep";
      case withings:
        return "withings";
      case googleFit:
        return "google_fit";
      case hammerhead:
        return "hammerhead";
      case dexcom:
        return "dexcom";
      case myFitnessPal:
        return "my_fitness_pal";
      case dexcomV3:
        return "dexcom_v3";
      case cronometer:
        return "cronometer";
      case polar:
        return "polar";
      case omron:
        return "omron";
    }
  }
}
