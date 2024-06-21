import 'package:json_annotation/json_annotation.dart';
import 'package:vital_core/services/data/source.dart';

part 'profile.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Profile {
  String userId;
  String id;
  double? height;
  Source source;

  Profile({
    required this.userId,
    required this.id,
    this.height,
    required this.source,
  });

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
