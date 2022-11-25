import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(createToJson: false)
class User {
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'user_key')
  String? userKey;
  @JsonKey(name: 'team_id')
  String? teamId;
  @JsonKey(name: 'client_user_id')
  String? clientUserId;
  @JsonKey(name: 'created_on')
  DateTime? createdOn;
  @JsonKey(name: 'connected_sources')
  List<ConnectedSource> connectedSources;

  User({
    this.userId,
    this.userKey,
    this.teamId,
    this.clientUserId,
    this.createdOn,
    this.connectedSources = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@JsonSerializable(createToJson: false)
class ConnectedSource {
  Source? source;
  @JsonKey(name: 'created_on')
  DateTime? createdOn;

  ConnectedSource({
    this.source,
    this.createdOn,
  });

  factory ConnectedSource.fromJson(Map<String, dynamic> json) => _$ConnectedSourceFromJson(json);
}

@JsonSerializable(createToJson: false)
class Source {
  String? name;
  String? slug;
  String? logo;

  Source({
    this.name,
    this.slug,
    this.logo,
  });

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);
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

  factory RefreshResponse.fromJson(Map<String, dynamic> json) => _$RefreshResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class ProvidersResponse {
  List<Source> providers;

  ProvidersResponse({
    this.providers = const [],
  });

  factory ProvidersResponse.fromJson(Map<String, dynamic> json) => _$ProvidersResponseFromJson(json);
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

  factory CreateUserResponse.fromJson(Map<String, dynamic> json) => _$CreateUserResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class DeleteUserResponse {
  bool success;
  String? error;

  DeleteUserResponse({
    this.success = false,
    this.error,
  });

  factory DeleteUserResponse.fromJson(Map<String, dynamic> json) => _$DeleteUserResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class DeregisterProviderResponse {
  bool success;

  DeregisterProviderResponse({
    this.success = false,
  });

  factory DeregisterProviderResponse.fromJson(Map<String, dynamic> json) => _$DeregisterProviderResponseFromJson(json);
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
