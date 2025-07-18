// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameModel _$GameModelFromJson(Map<String, dynamic> json) => _GameModel(
  appId: (json['appId'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  headerImage: json['headerImage'] as String,
  screenshots:
      (json['screenshots'] as List<dynamic>?)?.map((e) => e as String).toList(),
  price: json['price'] as Map<String, dynamic>?,
  installed: json['installed'] as bool? ?? false,
  playtimeHours: (json['playtimeHours'] as num?)?.toDouble(),
);

Map<String, dynamic> _$GameModelToJson(_GameModel instance) =>
    <String, dynamic>{
      'appId': instance.appId,
      'name': instance.name,
      'description': instance.description,
      'headerImage': instance.headerImage,
      'screenshots': instance.screenshots,
      'price': instance.price,
      'installed': instance.installed,
      'playtimeHours': instance.playtimeHours,
    };
