import 'package:json_annotation/json_annotation.dart';

part 'provider.g.dart';

// NOTE: Provider name clashes with popular package
// https://pub.dev/packages/provider
// when the package is imported without namespacing

@JsonSerializable(createToJson: false)
class UserConnection {
  String name;

  @JsonKey(unknownEnumValue: ProviderSlug.unrecognized)
  ProviderSlug slug;

  String? logo;
  UserConnectionStatus status;

  Map<String, ResourceAvailability> resourceAvailability;

  DateTime createdOn;

  UserConnection({
    required this.name,
    required this.slug,
    this.logo,
    required this.status,
    required this.resourceAvailability,
    required this.createdOn,
  });

  @override
  String toString() {
    return "$slug ($createdOn) (${status.name})";
  }

  factory UserConnection.fromJson(Map<String, dynamic> json) =>
      _$UserConnectionFromJson(json);
}

enum UserConnectionStatus {
  connected,
  error,
  paused;
}

@JsonSerializable(createToJson: false)
class ResourceAvailability {
  ResourceAvailabilityStatus status;
  ScopeRequirementsGrants? scopeRequirements;

  ResourceAvailability({
    required this.status,
    this.scopeRequirements,
  });

  @override
  String toString() {
    if (scopeRequirements != null) {
      return "${status.name} (with scope data)";
    } else {
      return "${status.name} (no scope data)";
    }
  }

  factory ResourceAvailability.fromJson(Map<String, dynamic> json) =>
      _$ResourceAvailabilityFromJson(json);
}

@JsonSerializable(createToJson: false)
class ScopeRequirementsGrants {
  ScopeRequirements userGranted;
  ScopeRequirements userDenied;

  ScopeRequirementsGrants({
    required this.userGranted,
    required this.userDenied,
  });

  factory ScopeRequirementsGrants.fromJson(Map<String, dynamic> json) =>
      _$ScopeRequirementsGrantsFromJson(json);
}

@JsonSerializable(createToJson: false)
class ScopeRequirements {
  List<String> required;
  List<String> optional;

  ScopeRequirements({
    required this.required,
    required this.optional,
  });

  factory ScopeRequirements.fromJson(Map<String, dynamic> json) =>
      _$ScopeRequirementsFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum ResourceAvailabilityStatus {
  available,
  unavailable;
}

@JsonEnum(fieldRename: FieldRename.snake, alwaysCreate: true)
enum ManualProviderSlug {
  @JsonValue("beurer_ble")
  beurerBLE,
  @JsonValue("omron_ble")
  omronBLE,
  @JsonValue("accuchek_ble")
  accuchekBLE,
  @JsonValue("contour_ble")
  contourBLE,
  @JsonValue("libre_ble")
  libreBLE,
  manual,
  appleHealthKit,
  healthConnect;

  @override
  String toString() {
    return _$ManualProviderSlugEnumMap[this]!;
  }
}

@JsonEnum(fieldRename: FieldRename.snake, alwaysCreate: true)
enum ProviderSlug {
  @JsonValue("beurer_ble")
  beurerBLE,
  @JsonValue("omron_ble")
  omronBLE,
  @JsonValue("accuchek_ble")
  accuchekBLE,
  @JsonValue("contour_ble")
  contourBLE,
  @JsonValue("libre_ble")
  libreBLE,
  manual,
  appleHealthKit,
  healthConnect,

  @JsonValue("ihealth")
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
  whoopV2,
  cronometer,
  polar,
  omron,
  kardia,
  abbottLibreview,

  unrecognized;

  static ProviderSlug fromString(String rawValue) {
    return $enumDecode(_$ProviderSlugEnumMap, rawValue,
        unknownValue: ProviderSlug.unrecognized);
  }

  @override
  String toString() {
    return _$ProviderSlugEnumMap[this]!;
  }
}
