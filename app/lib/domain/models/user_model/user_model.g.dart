// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  bio: json['bio'] as String?,
  typeUser: json['typeUser'] as String?,
  ownedGamesID:
      (json['ownedGamesID'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  favoriteGamesID:
      (json['favoriteGamesID'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  installedGamesID:
      (json['installedGamesID'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'avatarUrl': instance.avatarUrl,
      'bio': instance.bio,
      'typeUser': instance.typeUser,
      'ownedGamesID': instance.ownedGamesID,
      'favoriteGamesID': instance.favoriteGamesID,
      'installedGamesID': instance.installedGamesID,
    };
