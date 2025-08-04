// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ForumModel _$ForumModelFromJson(Map<String, dynamic> json) => _ForumModel(
  forumId: json['forumId'] as String,
  relatedGameId: json['relatedGameId'] as String,
  postsId:
      (json['postsId'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$ForumModelToJson(_ForumModel instance) =>
    <String, dynamic>{
      'forumId': instance.forumId,
      'relatedGameId': instance.relatedGameId,
      'postsId': instance.postsId,
    };
