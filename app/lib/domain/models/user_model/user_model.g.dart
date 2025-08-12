// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['userid'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  type: json['type'] as String,
  ownedGamesID: (json['ownedGamesID'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  wishlistGamesID: (json['wishlistGamesID'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  installedGamesID: (json['installedGamesID'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  description: json['description'] as String?,
  paymentMethod: json['paymentmethod'] == null
      ? null
      : PaymentMethodModel.fromJson(
          json['paymentmethod'] as Map<String, dynamic>,
        ),
  publishedGamesID: (json['publishedGamesID'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'userid': instance.id,
      'username': instance.username,
      'email': instance.email,
      'type': instance.type,
      'ownedGamesID': instance.ownedGamesID,
      'wishlistGamesID': instance.wishlistGamesID,
      'installedGamesID': instance.installedGamesID,
      'description': instance.description,
      'paymentmethod': instance.paymentMethod,
      'publishedGamesID': instance.publishedGamesID,
    };
