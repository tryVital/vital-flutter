import 'package:json_annotation/json_annotation.dart';
import 'package:vital_core/services/data/user.dart';

part 'control_plane.g.dart';

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
class GetAllUsersResponse {
  final List<User> users;

  GetAllUsersResponse({
    this.users = const [],
  });

  factory GetAllUsersResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllUsersResponseFromJson(json);
}
