import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';

part 'category_model.g.dart';

@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String name,
    required bool isSensitive,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, Object?> json) => 
    _$CategoryModelFromJson(json);
}