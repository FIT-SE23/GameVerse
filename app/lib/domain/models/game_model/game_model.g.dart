// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameModel _$GameModelFromJson(Map<String, dynamic> json) => _GameModel(
  gameId: json['gameId'] as String,
  publisherId: json['publisherId'] as String,
  name: json['name'] as String,
  recommended: (json['recommended'] as num).toInt(),
  briefDescription: json['briefDescription'] as String,
  description: json['description'] as String,
  requirements: json['requirements'] as String,
  headerImage: json['headerImage'] as String,
  price: (json['price'] as num).toDouble(),
  screenshots:
      (json['screenshots'] as List<dynamic>?)?.map((e) => e as String).toList(),
  categoriesId:
      (json['categoriesId'] as List<dynamic>).map((e) => e as String).toList(),
  isSale: json['isSale'] as bool?,
  discountPercent: (json['discountPercent'] as num?)?.toDouble(),
  saleStartDate:
      json['saleStartDate'] == null
          ? null
          : DateTime.parse(json['saleStartDate'] as String),
  saleEndDate:
      json['saleEndDate'] == null
          ? null
          : DateTime.parse(json['saleEndDate'] as String),
  isOwned: json['isOwned'] as bool? ?? false,
  installed: json['installed'] as bool? ?? false,
  favorite: json['favorite'] as bool? ?? false,
  playtimeHours: (json['playtimeHours'] as num?)?.toDouble(),
);

Map<String, dynamic> _$GameModelToJson(_GameModel instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'publisherId': instance.publisherId,
      'name': instance.name,
      'recommended': instance.recommended,
      'briefDescription': instance.briefDescription,
      'description': instance.description,
      'requirements': instance.requirements,
      'headerImage': instance.headerImage,
      'price': instance.price,
      'screenshots': instance.screenshots,
      'categoriesId': instance.categoriesId,
      'isSale': instance.isSale,
      'discountPercent': instance.discountPercent,
      'saleStartDate': instance.saleStartDate?.toIso8601String(),
      'saleEndDate': instance.saleEndDate?.toIso8601String(),
      'isOwned': instance.isOwned,
      'installed': instance.installed,
      'favorite': instance.favorite,
      'playtimeHours': instance.playtimeHours,
    };
