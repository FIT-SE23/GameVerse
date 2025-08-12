// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    _CategoryModel(
      categoryId: json['categoryid'] as String,
      name: json['name'] as String,
      isSensitive: json['issensitive'] as bool,
    );

Map<String, dynamic> _$CategoryModelToJson(_CategoryModel instance) =>
    <String, dynamic>{
      'categoryid': instance.categoryId,
      'name': instance.name,
      'issensitive': instance.isSensitive,
    };
