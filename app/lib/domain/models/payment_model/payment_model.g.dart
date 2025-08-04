// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) =>
    _PaymentModel(
      forumId: json['forumId'] as String,
      relatedGameId: json['relatedGameId'] as String,
      postsId:
          (json['postsId'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PaymentModelToJson(_PaymentModel instance) =>
    <String, dynamic>{
      'forumId': instance.forumId,
      'relatedGameId': instance.relatedGameId,
      'postsId': instance.postsId,
    };
