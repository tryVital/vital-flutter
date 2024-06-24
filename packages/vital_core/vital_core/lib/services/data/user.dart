import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class User {
  String userId;
  String teamId;
  String clientUserId;
  DateTime createdOn;
  UserFallbackTimeZone? fallbackTimeZone;

  User({
    required this.userId,
    required this.teamId,
    required this.clientUserId,
    required this.createdOn,
    this.fallbackTimeZone,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@JsonSerializable(createToJson: false)
class UserFallbackTimeZone {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'source_slug')
  String sourceSlug;

  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;

  UserFallbackTimeZone(
    this.id,
    this.sourceSlug,
    this.updatedAt,
  );

  factory UserFallbackTimeZone.fromJson(Map<String, dynamic> json) =>
      _$UserFallbackTimeZoneFromJson(json);
}

@JsonSerializable(createToJson: false)
class RefreshResponse {
  bool success;
  @JsonKey(name: 'user_id')
  String? userId;
  String? error;
  @JsonKey(name: 'refreshed_sources')
  List<String> refreshedSources;
  @JsonKey(name: 'failed_sources')
  List<String> failedSources;

  RefreshResponse({
    this.success = false,
    this.error,
    this.userId,
    this.refreshedSources = const [],
    this.failedSources = const [],
  });

  factory RefreshResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class DeregisterProviderResponse {
  bool success;

  DeregisterProviderResponse({
    this.success = false,
  });

  factory DeregisterProviderResponse.fromJson(Map<String, dynamic> json) =>
      _$DeregisterProviderResponseFromJson(json);
}
