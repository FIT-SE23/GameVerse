// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      transactionId: json['transactionid'] as String,
      senderId: json['senderid'] as String,
      gameId: json['gameid'] as String,
      amount: (json['amount'] as num).toDouble(),
      transactionDate: DateTime.parse(json['transactiondate'] as String),
      status: json['status'] as String,
      isRefundable: json['isRefundable'] as bool,
    );

Map<String, dynamic> _$TransactionModelToJson(_TransactionModel instance) =>
    <String, dynamic>{
      'transactionid': instance.transactionId,
      'senderid': instance.senderId,
      'gameid': instance.gameId,
      'amount': instance.amount,
      'transactiondate': instance.transactionDate.toIso8601String(),
      'status': instance.status,
      'isRefundable': instance.isRefundable,
    };
