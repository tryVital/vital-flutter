import 'package:json_annotation/json_annotation.dart';
import 'package:vital_core/provider.dart';

part 'providers.g.dart';

enum ProviderAuthType {
  @JsonValue("oauth")
  oauth,
  @JsonValue("team_oauth")
  teamOauth,
  @JsonValue("password")
  password,
  @JsonValue("email")
  email,
  @JsonValue("sdk")
  sdk,
  @JsonValue("")
  none,
}

@JsonSerializable(createToJson: false)
class AvailableProvider {
  String name;
  String slug;
  String description;
  String logo;

  @JsonKey(name: 'auth_type')
  ProviderAuthType? authType;

  AvailableProvider({
    required this.name,
    required this.slug,
    required this.description,
    required this.logo,
    this.authType,
  });

  factory AvailableProvider.fromJson(Map<String, dynamic> json) =>
      _$AvailableProviderFromJson(json);

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
