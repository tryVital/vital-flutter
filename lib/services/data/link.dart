import 'package:json_annotation/json_annotation.dart';

part 'link.g.dart';

@JsonSerializable(createToJson: false)
class CreateLinkResponse {
  @JsonKey(name: 'link_token')
  String? linkToken;

  CreateLinkResponse({
    this.linkToken,
  });

  factory CreateLinkResponse.fromJson(Map<String, dynamic> json) => _$CreateLinkResponseFromJson(json);
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

  factory OauthLinkResponse.fromJson(Map<String, dynamic> json) => _$OauthLinkResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class EmailProviderResponse {
  bool success;
  @JsonKey(name: 'redirect_url')
  String? redirectUrl;

  EmailProviderResponse({
    this.redirectUrl,
    this.success = false,
  });

  factory EmailProviderResponse.fromJson(Map<String, dynamic> json) => _$EmailProviderResponseFromJson(json);
}
