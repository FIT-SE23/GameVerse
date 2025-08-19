// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommentModel _$CommentModelFromJson(Map<String, dynamic> json) =>
    _CommentModel(
      commentId: json['commentid'] as String,
      userId: json['userid'] as String,
      postId: json['postid'] as String,
      content: json['content'] as String,
      recommend: (json['recommend'] as num).toInt(),
      commentDate: DateTime.parse(json['commentdate'] as String),
    );

Map<String, dynamic> _$CommentModelToJson(_CommentModel instance) =>
    <String, dynamic>{
      'commentid': instance.commentId,
      'userid': instance.userId,
      'postid': instance.postId,
      'content': instance.content,
      'recommend': instance.recommend,
      'commentdate': instance.commentDate.toIso8601String(),
    };
