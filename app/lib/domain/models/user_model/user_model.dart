import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gameverse/domain/models/payment_method_model/payment_method_model.dart';

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
    @Default('publisher') String type, // e.g., 'user', 'operator', 'publisher'

    // Optional fields for user preferences
    List<String>? ownedGamesID,
    List<String>? favoriteGamesID,
    List<String>? installedGamesID,

    // Optional fields for publisher
    String? description,
    PaymentMethodModel? paymentMethod,
    DateTime? registrationDate,
    List<String>? gamesPublishedID,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) => 
    _$UserModelFromJson(json);
}