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
    required String description,
    required String briefDescription,
    required String requirement,
    required double price,
    required int recommended,
    required DateTime releaseDate,
    required List<CategoryModel> categories,
    required List<String>? media,
    required String headerImage,

    // Request related fields
    String? requestStatus, // e.g., 'pending', 'approved', 'rejected'

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
    @Default(false) bool isInstalled,
    @Default(false) bool favorite,
    double? playtimeHours,
  }) = _GameModel;

  factory GameModel.fromJson(Map<String, dynamic> json) => 
      _$GameModelFromJson(json);
}