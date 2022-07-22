import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  @JsonKey(name: 'user_id')
  String userId;
  @JsonKey(name: 'user_key')
  String? userKey;
  String id;
  double? height;
  Source? source;

  Profile({
    required this.userId,
    this.userKey,
    required this.id,
    this.height,
    this.source,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}
