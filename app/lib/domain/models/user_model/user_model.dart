import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String username,
    required String email,
    String? avatar,
    String? bio,
    String? type, // e.g., 'user', 'operator'

    // Optional fields for user preferences
    List<String>? ownedGamesID,
    List<String>? favoriteGamesID,
    List<String>? installedGamesID,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) => 
    _$UserModelFromJson(json);
}