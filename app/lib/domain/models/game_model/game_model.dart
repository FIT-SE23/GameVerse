import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_model.freezed.dart';
part 'game_model.g.dart';

@freezed
abstract class GameModel with _$GameModel {
  const factory GameModel({
    required String gameId,
    required String name,
    required int recommended,
    required String briefDescription,
    required String description,
    required String requirements,
    required String headerImage,
    List<String>? screenshots,
    Map<String, dynamic>? price,
    required List<String> categoriesID,

    // Sale related fields
    bool? isSale,
    double? discountPercent,
    DateTime? saleStartDate,
    DateTime? saleEndDate,

    // Field for User only
    @Default(false) bool isOwned,
    @Default(false) bool installed,
    @Default(false) bool favorite,
    double? playtimeHours,
  }) = _GameModel;

  factory GameModel.fromJson(Map<String, dynamic> json) => 
      _$GameModelFromJson(json);
}