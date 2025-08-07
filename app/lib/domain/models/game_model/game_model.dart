import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gameverse/domain/models/category_model/category_model.dart';

part 'game_model.freezed.dart';
part 'game_model.g.dart';

@freezed
abstract class GameModel with _$GameModel {
  const factory GameModel({
    required String gameId,
    required String publisherId,
    required String name,
    required int recommended,
    required String briefDescription,
    required String description,
    required String requirements,
    required String headerImage,
    required double price,
    required List<CategoryModel> categories,
    required List<String>? media,
    required DateTime releaseDate,

    // Request related fields
    String? requestId,
    String? requestStatus, // e.g., 'pending', 'approved', 'rejected
    String? requestMessage, // Message from the publisher regarding the request

    // Sale related fields
    bool? isSale,
    double? discountPercent,
    DateTime? saleStartDate,
    DateTime? saleEndDate,

    // Download related fields
    String? path,
    List<String>? binaries,
    List<String>? exes,

    // Field for User only
    @Default(false) bool isOwned,
    @Default(false) bool installed,
    @Default(false) bool favorite,
    double? playtimeHours,
  }) = _GameModel;

  factory GameModel.fromJson(Map<String, dynamic> json) => 
      _$GameModelFromJson(json);

  
}