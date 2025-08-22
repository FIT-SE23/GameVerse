import 'package:freezed_annotation/freezed_annotation.dart';

part 'url_model.freezed.dart';
part 'url_model.g.dart';

@freezed
abstract class UrlModel with _$UrlModel {
  const factory UrlModel({
    @JsonKey(name: 'urlid') String? urlId,
    @JsonKey(name: 'url') required String url,
    @JsonKey(name: 'checksum') String? checksum,
  }) = _UrlModel;

  factory UrlModel.fromJson(Map<String, dynamic> json) => 
      _$UrlModelFromJson(json);
}