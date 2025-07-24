import 'package:freezed_annotation/freezed_annotation.dart';

part 'publisher_model.freezed.dart';

part 'publisher_model.g.dart';

@freezed
abstract class PublisherModel with _$PublisherModel {
  const factory PublisherModel({
    required String id,
    List<String>? gamesPublishedID,
    required String description,
    required String name,
  }) = _PublisherModel;

  factory PublisherModel.fromJson(Map<String, Object?> json) => 
    _$PublisherModelFromJson(json);
}