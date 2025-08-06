// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  avatar: json['avatar'] as String?,
  bio: json['bio'] as String?,
  type: json['type'] as String?,
  ownedGamesID: (json['ownedGamesID'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  favoriteGamesID: (json['favoriteGamesID'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  installedGamesID: (json['installedGamesID'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'avatar': instance.avatar,
      'bio': instance.bio,
      'type': instance.type,
      'ownedGamesID': instance.ownedGamesID,
      'favoriteGamesID': instance.favoriteGamesID,
      'installedGamesID': instance.installedGamesID,
    };
