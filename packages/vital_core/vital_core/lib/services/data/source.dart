import 'package:json_annotation/json_annotation.dart';
import 'package:vital_core/provider.dart';

part 'source.g.dart';

@JsonSerializable(createToJson: false)
class Source {
  @JsonKey(unknownEnumValue: ProviderSlug.unrecognized)
  ProviderSlug provider;

  @JsonKey(unknownEnumValue: SourceType.unrecognized)
  SourceType type;

  String? appId;

  Source({
    required this.provider,
    required this.type,
    this.appId,
  });

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum SourceType {
  phone,
  watch,
  app,
  ring,
  scale,
  multipleSources,
  chestStrap,
  manualScan,
  automatic,
  cuff,
  fingerprick,
  unknown,

  unrecognized;
}
