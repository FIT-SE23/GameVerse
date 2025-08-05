import 'package:freezed_annotation/freezed_annotation.dart';

part 'resource_model.freezed.dart';

part 'resource_model.g.dart';

@freezed
abstract class ResourceModel with _$ResourceModel {
  const factory ResourceModel({
    required String resourceId,
    required String type, // e.g., "image", "video", "audio"
    required String url, // URL to the resource
  }) = _ResourceModel;

  factory ResourceModel.fromJson(Map<String, Object?> json) => 
    _$ResourceModelFromJson(json);
}