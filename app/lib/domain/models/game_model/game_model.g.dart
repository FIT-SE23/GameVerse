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
  categories: (json['categories'] as List<dynamic>)
      .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  media: (json['media'] as List<dynamic>?)?.map((e) => e as String).toList(),
  releaseDate: DateTime.parse(json['releaseDate'] as String),
  isSale: json['isSale'] as bool?,
  discountPercent: (json['discountPercent'] as num?)?.toDouble(),
  saleStartDate: json['saleStartDate'] == null
      ? null
      : DateTime.parse(json['saleStartDate'] as String),
  saleEndDate: json['saleEndDate'] == null
      ? null
      : DateTime.parse(json['saleEndDate'] as String),
  path: json['path'] as String?,
  binaries: (json['binaries'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  exes: (json['exes'] as List<dynamic>?)?.map((e) => e as String).toList(),
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
      'categories': instance.categories,
      'media': instance.media,
      'releaseDate': instance.releaseDate.toIso8601String(),
      'isSale': instance.isSale,
      'discountPercent': instance.discountPercent,
      'saleStartDate': instance.saleStartDate?.toIso8601String(),
      'saleEndDate': instance.saleEndDate?.toIso8601String(),
      'path': instance.path,
      'binaries': instance.binaries,
      'exes': instance.exes,
      'isOwned': instance.isOwned,
      'installed': instance.installed,
      'favorite': instance.favorite,
      'playtimeHours': instance.playtimeHours,
    };
