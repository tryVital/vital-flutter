import 'package:json_annotation/json_annotation.dart';
import 'package:vital_core/services/data/providers.dart';

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
class ProvidersResponse {
  List<AvailableProvider> providers;

  ProvidersResponse({
    this.providers = const [],
  });

  factory ProvidersResponse.fromJson(Map<String, dynamic> json) =>
      _$ProvidersResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class CreateUserResponse {
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'user_key')
  String? userKey;
  @JsonKey(name: 'client_user_id')
  String? clientUserId;

  CreateUserResponse({
    this.userId,
    this.userKey,
    this.clientUserId,
  });

  factory CreateUserResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateUserResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class CreateSignInTokenResponse {
  @JsonKey(name: 'user_id')
  String userId;
  @JsonKey(name: 'sign_in_token')
  String signInToken;

  CreateSignInTokenResponse({
    required this.userId,
    required this.signInToken,
  });

  factory CreateSignInTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateSignInTokenResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class DeleteUserResponse {
  bool success;
  String? error;

  DeleteUserResponse({
    this.success = false,
    this.error,
  });

  factory DeleteUserResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteUserResponseFromJson(json);
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

@JsonSerializable(createToJson: false)
class GetAllUsersResponse {
  final List<User> users;

  GetAllUsersResponse({
    this.users = const [],
  });

  factory GetAllUsersResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllUsersResponseFromJson(json);
}
