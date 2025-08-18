// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      transactionId: json['transactionid'] as String?,
      senderId: json['senderid'] as String,
      gameId: json['gameid'] as String,
      moneyAmount: (json['moneyamount'] as num).toDouble(),
      transactionDate: DateTime.parse(json['transactiondate'] as String),
      isRefundable: json['isrefundable'] as bool,
      paymentMethodId: json['paymentmethodid'] as String,
      status: json['status'] as String? ?? 'completed',
    );

Map<String, dynamic> _$TransactionModelToJson(_TransactionModel instance) =>
    <String, dynamic>{
      'transactionid': instance.transactionId,
      'senderid': instance.senderId,
      'gameid': instance.gameId,
      'moneyamount': instance.moneyAmount,
      'transactiondate': instance.transactionDate.toIso8601String(),
      'isrefundable': instance.isRefundable,
      'paymentmethodid': instance.paymentMethodId,
      'status': instance.status,
    };
