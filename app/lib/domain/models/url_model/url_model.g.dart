// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UrlModel _$UrlModelFromJson(Map<String, dynamic> json) => _UrlModel(
  urlId: json['urlid'] as String?,
  url: json['url'] as String,
  checksum: json['checksum'] as String?,
);

Map<String, dynamic> _$UrlModelToJson(_UrlModel instance) => <String, dynamic>{
  'urlid': instance.urlId,
  'url': instance.url,
  'checksum': instance.checksum,
};
