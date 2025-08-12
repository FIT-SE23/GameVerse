// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentMethodModel _$PaymentMethodModelFromJson(Map<String, dynamic> json) =>
    _PaymentMethodModel(
      paymentMethodId: json['paymentmethodid'] as String,
      type: json['type'] as String,
      information: json['information'] as String,
    );

Map<String, dynamic> _$PaymentMethodModelToJson(_PaymentMethodModel instance) =>
    <String, dynamic>{
      'paymentmethodid': instance.paymentMethodId,
      'type': instance.type,
      'information': instance.information,
    };
