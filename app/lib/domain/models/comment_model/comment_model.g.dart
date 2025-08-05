// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommentModel _$CommentModelFromJson(Map<String, dynamic> json) =>
    _CommentModel(
      commentId: json['commentId'] as String,
      relatedGameId: json['relatedGameId'] as String,
      postsId: (json['postsId'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CommentModelToJson(_CommentModel instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'relatedGameId': instance.relatedGameId,
      'postsId': instance.postsId,
    };
