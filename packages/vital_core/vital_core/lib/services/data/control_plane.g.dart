// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'control_plane.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateUserResponse _$CreateUserResponseFromJson(Map<String, dynamic> json) =>
    CreateUserResponse(
      userId: json['user_id'] as String?,
      clientUserId: json['client_user_id'] as String?,
    );

CreateSignInTokenResponse _$CreateSignInTokenResponseFromJson(
        Map<String, dynamic> json) =>
    CreateSignInTokenResponse(
      userId: json['user_id'] as String,
      signInToken: json['sign_in_token'] as String,
    );

DeleteUserResponse _$DeleteUserResponseFromJson(Map<String, dynamic> json) =>
    DeleteUserResponse(
      success: json['success'] as bool? ?? false,
      error: json['error'] as String?,
    );

GetAllUsersResponse _$GetAllUsersResponseFromJson(Map<String, dynamic> json) =>
    GetAllUsersResponse(
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
