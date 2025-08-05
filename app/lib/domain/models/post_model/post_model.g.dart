// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostModel _$PostModelFromJson(Map<String, dynamic> json) => _PostModel(
  id: json['id'] as String,
  content: json['content'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  upvotes: (json['upvotes'] as num).toInt(),
  forumId: json['forumId'] as String,
  authorId: json['authorId'] as String,
  commentsId: (json['commentsId'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$PostModelToJson(_PostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'upvotes': instance.upvotes,
      'forumId': instance.forumId,
      'authorId': instance.authorId,
      'commentsId': instance.commentsId,
    };
