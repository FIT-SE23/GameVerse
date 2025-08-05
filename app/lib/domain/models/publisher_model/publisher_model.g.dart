// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publisher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PublisherModel _$PublisherModelFromJson(Map<String, dynamic> json) =>
    _PublisherModel(
      id: json['id'] as String,
      description: json['description'] as String,
      name: json['name'] as String,
      gamesPublishedID: (json['gamesPublishedID'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PublisherModelToJson(_PublisherModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'name': instance.name,
      'gamesPublishedID': instance.gamesPublishedID,
    };
