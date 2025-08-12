import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gameverse/domain/models/payment_method_model/payment_method_model.dart';

part 'user_model.freezed.dart';

part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: 'userid') required String id,
    required String username,
    required String email,
    required String type, // e.g., 'user', 'operator', 'publisher'

    // Optional fields for user preferences
    List<String>? ownedGamesID,
    List<String>? wishlistGamesID,
    List<String>? installedGamesID,

    // Optional fields for publisher
    String? description,
    @JsonKey(name: 'paymentmethod') PaymentMethodModel? paymentMethod,
    List<String>? publishedGamesID,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) => 
    _$UserModelFromJson(json);
}