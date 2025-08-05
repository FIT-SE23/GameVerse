import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_method_model.freezed.dart';

part 'payment_method_model.g.dart';

@freezed
abstract class PaymentMethodModel with _$PaymentMethodModel {
  const factory PaymentMethodModel({
    required String paymentMethodId,
    required String type, // e.g., "paypal"
    required String information,
  }) = _PaymentMethodModel;

  factory PaymentMethodModel.fromJson(Map<String, Object?> json) => 
    _$PaymentMethodModelFromJson(json);
}