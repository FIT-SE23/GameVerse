import 'package:freezed_annotation/freezed_annotation.dart';

part 'publisher_model.freezed.dart';

part 'publisher_model.g.dart';

@freezed
abstract class PublisherModel with _$PublisherModel {
  const factory PublisherModel({
    required String id,
    required String description,
    required String name,
    List<String>? gamesPublishedID,
  }) = _PublisherModel;

  factory PublisherModel.fromJson(Map<String, Object?> json) => 
    _$PublisherModelFromJson(json);
}