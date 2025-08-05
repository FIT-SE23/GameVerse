import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gameverse/domain/models/resource_model/resource_model.dart';

part 'user_model.freezed.dart';

part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String username,
    required String email,
    ResourceModel? avatar,
    String? bio,
    String? typeUser,

    // Optional fields for user preferences
    List<String>? ownedGamesID,
    List<String>? favoriteGamesID,
    List<String>? installedGamesID,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) => 
    _$UserModelFromJson(json);
}