import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gameverse/domain/models/category_model/category_model.dart';

part 'game_model.freezed.dart';
part 'game_model.g.dart';

@freezed
abstract class GameModel with _$GameModel {
  const factory GameModel({
    @JsonKey(name: 'gameid') required String gameId,
    @JsonKey(name: 'publisherid') required String publisherId,
    required String name,
    required String description,
    @JsonKey(name: 'briefdescription') required String briefDescription,
    required String requirement,
    required double price,
    @JsonKey(name: 'recommend') required int recommended,
    @JsonKey(name: 'releasedate') required DateTime releaseDate,
    required List<CategoryModel> categories,
    required List<String>? media,
    @JsonKey(name: 'headerimage') required String headerImage,

    // Request related fields
    @JsonKey(name: 'isverified') bool? isVerified, // e.g., 'pending', 'approved', 'rejected'

    // Sale related fields
    @JsonKey(name: 'issale') bool? isSale,
    @JsonKey(name: 'discountpercent') double? discountPercent,
    @JsonKey(name: 'salestartdate') DateTime? saleStartDate,
    @JsonKey(name: 'saleenddate') DateTime? saleEndDate,

    // Download related fields
    String? path,
    List<String>? binaries,
    List<String>? exes,

    // Field for User only
    @JsonKey(name: 'isowned') @Default(false) bool isOwned,
    @JsonKey(name: 'isinstalled') @Default(false) bool isInstalled,
    @JsonKey(name: 'isinwishlist') @Default(false) bool isInWishlist,
    @JsonKey(name: 'playtimehours') double? playtimeHours,
  }) = _GameModel;

  factory GameModel.fromJson(Map<String, dynamic> json) => 
      _$GameModelFromJson(json);
}