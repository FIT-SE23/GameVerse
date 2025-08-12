// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostModel _$PostModelFromJson(Map<String, dynamic> json) => _PostModel(
  postId: json['postid'] as String,
  authorId: json['userid'] as String,
  forumId: json['forumid'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  upvotes: (json['upvotes'] as num).toInt(),
  createdAt: DateTime.parse(json['postdate'] as String),
  commentsId: (json['commentsId'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$PostModelToJson(_PostModel instance) =>
    <String, dynamic>{
      'postid': instance.postId,
      'userid': instance.authorId,
      'forumid': instance.forumId,
      'title': instance.title,
      'content': instance.content,
      'upvotes': instance.upvotes,
      'postdate': instance.createdAt.toIso8601String(),
      'commentsId': instance.commentsId,
    };
