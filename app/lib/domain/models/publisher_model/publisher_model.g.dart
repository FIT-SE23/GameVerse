// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publisher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PublisherModel _$PublisherModelFromJson(Map<String, dynamic> json) =>
    _PublisherModel(
      id: json['id'] as String,
      gamesPublishedID:
          (json['gamesPublishedID'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      description: json['description'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$PublisherModelToJson(_PublisherModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gamesPublishedID': instance.gamesPublishedID,
      'description': instance.description,
      'name': instance.name,
    };
