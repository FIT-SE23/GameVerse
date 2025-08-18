// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameRequestModel _$GameRequestModelFromJson(Map<String, dynamic> json) =>
    _GameRequestModel(
      requestId: json['requestid'] as String?,
      publisherId: json['publisherid'] as String,
      gameName: json['gamename'] as String,
      briefDescription: json['briefdescription'] as String,
      description: json['description'] as String,
      requirements: json['requirements'] as String,
      headerImage: json['headerimage'] as String,
      price: (json['price'] as num).toDouble(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      media: (json['media'] as List<dynamic>).map((e) => e as String).toList(),
      submissionDate: DateTime.parse(json['releasedate'] as String),
      status: json['status'] as String,
      binaries: (json['binaries'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      exes: (json['exes'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$GameRequestModelToJson(_GameRequestModel instance) =>
    <String, dynamic>{
      'requestid': instance.requestId,
      'publisherid': instance.publisherId,
      'gamename': instance.gameName,
      'briefdescription': instance.briefDescription,
      'description': instance.description,
      'requirements': instance.requirements,
      'headerimage': instance.headerImage,
      'price': instance.price,
      'categories': instance.categories,
      'media': instance.media,
      'releasedate': instance.submissionDate.toIso8601String(),
      'status': instance.status,
      'binaries': instance.binaries,
      'exes': instance.exes,
    };
