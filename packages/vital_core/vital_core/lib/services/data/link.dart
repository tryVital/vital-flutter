import 'package:json_annotation/json_annotation.dart';

part 'link.g.dart';

@JsonSerializable()
class IsLinkTokenValidRequest {
  @JsonKey(name: 'token')
  String linkToken;

  IsLinkTokenValidRequest({
    required this.linkToken,
  });

  factory IsLinkTokenValidRequest.fromJson(Map<String, dynamic> json) =>
      _$IsLinkTokenValidRequestFromJson(json);

  Map<String, dynamic> toJson() => _$IsLinkTokenValidRequestToJson(this);
}

@JsonSerializable(createToJson: false)
class CreateLinkResponse {
  @JsonKey(name: 'link_token')
  String linkToken;

  CreateLinkResponse({
    required this.linkToken,
  });

  factory CreateLinkResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateLinkResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class OauthLinkResponse {
  String? name;
  String? slug;
  String? description;
  String? logo;
  String? group;
  @JsonKey(name: 'oauth_url')
  String? oauthUrl;
  @JsonKey(name: 'auth_type')
  String? authType;
  @JsonKey(name: 'is_active')
  bool isActive;
  int id;

  OauthLinkResponse({
    this.name,
    this.slug,
    this.description,
    this.logo,
    this.group,
    this.oauthUrl,
    this.authType,
    this.isActive = false,
    this.id = -1,
  });

  factory OauthLinkResponse.fromJson(Map<String, dynamic> json) =>
      _$OauthLinkResponseFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum LinkState {
  success,
  error,
  pendingProviderMfa;
}

@JsonEnum(fieldRename: FieldRename.snake)
enum LinkProviderMFAMethod {
  sms,
  email;
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class LinkResponse {
  LinkState state;
  String? redirectUrl;

  String? errorType;
  String? error;
  LinkProviderMFA? providerMfa;

  LinkResponse({
    required this.state,
    this.redirectUrl,
    this.errorType,
    this.error,
    this.providerMfa,
  });

  factory LinkResponse.fromJson(Map<String, dynamic> json) =>
      _$LinkResponseFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class LinkProviderMFA {
  LinkProviderMFAMethod method;
  String hint;

  LinkProviderMFA({
    required this.method,
    required this.hint,
  });

  factory LinkProviderMFA.fromJson(Map<String, dynamic> json) =>
      _$LinkProviderMFAFromJson(json);
}
