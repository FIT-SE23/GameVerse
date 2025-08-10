// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameRequestModel _$GameRequestModelFromJson(Map<String, dynamic> json) =>
    _GameRequestModel(
      publisherId: json['publisherId'] as String,
      gameName: json['gameName'] as String,
      briefDescription: json['briefDescription'] as String,
      description: json['description'] as String,
      requirements: json['requirements'] as String,
      headerImage: json['headerImage'] as String,
      price: (json['price'] as num).toDouble(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      requestStatus: json['requestStatus'] as String,
      binaries: (json['binaries'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      exes: (json['exes'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$GameRequestModelToJson(_GameRequestModel instance) =>
    <String, dynamic>{
      'publisherId': instance.publisherId,
      'gameName': instance.gameName,
      'briefDescription': instance.briefDescription,
      'description': instance.description,
      'requirements': instance.requirements,
      'headerImage': instance.headerImage,
      'price': instance.price,
      'categories': instance.categories,
      'media': instance.media,
      'requestStatus': instance.requestStatus,
      'binaries': instance.binaries,
      'exes': instance.exes,
    };
