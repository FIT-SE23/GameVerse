// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameModel _$GameModelFromJson(Map<String, dynamic> json) => _GameModel(
  gameId: json['gameid'] as String,
  publisherId: json['publisherid'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  briefDescription: json['briefdescription'] as String,
  requirement: json['requirement'] as String,
  price: (json['price'] as num).toDouble(),
  recommended: (json['recommend'] as num).toInt(),
  releaseDate: DateTime.parse(json['releasedate'] as String),
  categories: (json['categories'] as List<dynamic>)
      .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  media: (json['media'] as List<dynamic>?)?.map((e) => e as String).toList(),
  headerImage: json['headerimage'] as String,
  requestStatus: json['requeststatus'] as String?,
  isSale: json['issale'] as bool?,
  discountPercent: (json['discountpercent'] as num?)?.toDouble(),
  saleStartDate: json['salestartdate'] == null
      ? null
      : DateTime.parse(json['salestartdate'] as String),
  saleEndDate: json['saleenddate'] == null
      ? null
      : DateTime.parse(json['saleenddate'] as String),
  path: json['path'] as String?,
  binaries: (json['binaries'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  exes: (json['exes'] as List<dynamic>?)?.map((e) => e as String).toList(),
  isOwned: json['isowned'] as bool? ?? false,
  isInstalled: json['isinstalled'] as bool? ?? false,
  isInWishlist: json['isinwishlist'] as bool? ?? false,
  playtimeHours: (json['playtimehours'] as num?)?.toDouble(),
);

Map<String, dynamic> _$GameModelToJson(_GameModel instance) =>
    <String, dynamic>{
      'gameid': instance.gameId,
      'publisherid': instance.publisherId,
      'name': instance.name,
      'description': instance.description,
      'briefdescription': instance.briefDescription,
      'requirement': instance.requirement,
      'price': instance.price,
      'recommend': instance.recommended,
      'releasedate': instance.releaseDate.toIso8601String(),
      'categories': instance.categories,
      'media': instance.media,
      'headerimage': instance.headerImage,
      'requeststatus': instance.requestStatus,
      'issale': instance.isSale,
      'discountpercent': instance.discountPercent,
      'salestartdate': instance.saleStartDate?.toIso8601String(),
      'saleenddate': instance.saleEndDate?.toIso8601String(),
      'path': instance.path,
      'binaries': instance.binaries,
      'exes': instance.exes,
      'isowned': instance.isOwned,
      'isinstalled': instance.isInstalled,
      'isinwishlist': instance.isInWishlist,
      'playtimehours': instance.playtimeHours,
    };
