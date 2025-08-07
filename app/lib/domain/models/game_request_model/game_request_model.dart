import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gameverse/domain/models/category_model/category_model.dart';

part 'game_request_model.freezed.dart';
part 'game_request_model.g.dart';

@freezed
abstract class GameRequestModel with _$GameRequestModel {
  const factory GameRequestModel({
    required String publisherId,
    required String gameName,
    required String briefDescription,
    required String description,
    required String requirements,
    required String headerImage,
    required double price,
    required List<CategoryModel> categories,
    required List<String>? media,

    // Request related fields
    String? requestId,
    required String requestStatus, // e.g., 'pending', 'approved', 'rejected
    String? requestMessage, // Message from the publisher regarding the request
    required DateTime requestDate,

    // Upload related fields
    List<String>? binaries,
    List<String>? exes,
  }) = _GameRequestModel;

  factory GameRequestModel.fromJson(Map<String, dynamic> json) => 
      _$GameRequestModelFromJson(json);

  
}