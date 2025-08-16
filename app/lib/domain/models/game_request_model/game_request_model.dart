import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gameverse/domain/models/category_model/category_model.dart';

part 'game_request_model.freezed.dart';
part 'game_request_model.g.dart';

@freezed
abstract class GameRequestModel with _$GameRequestModel {
  const factory GameRequestModel({
    @JsonKey(name: 'requestid') String? requestId,
    @JsonKey(name: 'publisherid') required String publisherId,
    @JsonKey(name: 'gamename') required String gameName,
    @JsonKey(name: 'briefdescription') required String briefDescription,
    required String description,
    required String requirements,
    @JsonKey(name: 'headerimage') required String headerImage,
    required double price,
    required List<CategoryModel> categories,
    required List<String> media,
    @JsonKey(name: 'releasedate') required DateTime submissionDate,

    // Request related fields
    @JsonKey(name: 'status') required String status, // e.g., 'pending', 'approved', 'rejected

    // Upload related fields
    required List<String> binaries,
    required List<String> exes,
  }) = _GameRequestModel;

  factory GameRequestModel.fromJson(Map<String, dynamic> json) => 
      _$GameRequestModelFromJson(json);

  
}