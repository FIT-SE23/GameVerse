import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_model.freezed.dart';

part 'payment_model.g.dart';

@freezed
abstract class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required String forumId,
    required String relatedGameId,
    List<String>? postsId,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, Object?> json) => 
    _$PaymentModelFromJson(json);
}