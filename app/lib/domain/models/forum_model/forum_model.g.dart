// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ForumModel _$ForumModelFromJson(Map<String, dynamic> json) => _ForumModel(
  gameId: json['gameid'] as String,
  name: json['name'] as String,
  briefDescription: json['briefdescription'] as String,
  headerImage: json['headerimage'] as String,
);

Map<String, dynamic> _$ForumModelToJson(_ForumModel instance) =>
    <String, dynamic>{
      'gameid': instance.gameId,
      'name': instance.name,
      'briefdescription': instance.briefDescription,
      'headerimage': instance.headerImage,
    };
