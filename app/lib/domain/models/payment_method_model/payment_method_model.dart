import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_method_model.freezed.dart';

part 'payment_method_model.g.dart';

@freezed
abstract class PaymentMethodModel with _$PaymentMethodModel {
  const factory PaymentMethodModel({
    @JsonKey(name: 'paymentmethodid') required String paymentMethodId,
    required String type, // e.g., "banking"
    required String information, // e.g., "PayPal", "Credit Card"
  }) = _PaymentMethodModel;

  factory PaymentMethodModel.fromJson(Map<String, Object?> json) => 
    _$PaymentMethodModelFromJson(json);
}