// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ForumModel _$ForumModelFromJson(Map<String, dynamic> json) => _ForumModel(
  id: json['id'] as String,
  relatedGameId: json['relatedGameId'] as String,
  postsId:
      (json['postsId'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$ForumModelToJson(_ForumModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'relatedGameId': instance.relatedGameId,
      'postsId': instance.postsId,
    };
