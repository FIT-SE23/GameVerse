// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResourceModel _$ResourceModelFromJson(Map<String, dynamic> json) =>
    _ResourceModel(
      resourceId: json['resourceId'] as String,
      type: json['type'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$ResourceModelToJson(_ResourceModel instance) =>
    <String, dynamic>{
      'resourceId': instance.resourceId,
      'type': instance.type,
      'url': instance.url,
    };
