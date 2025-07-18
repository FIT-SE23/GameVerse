import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_model.freezed.dart';
part 'game_model.g.dart';

@freezed
abstract class GameModel with _$GameModel {
  const factory GameModel({
    required int appId,
    required String name,
    String? description,
    required String headerImage,
    List<String>? screenshots,
    Map<String, dynamic>? price,
    @Default(false) bool installed,
    double? playtimeHours,
  }) = _GameModel;

  factory GameModel.fromJson(Map<String, dynamic> json) => 
      _$GameModelFromJson(json);
}